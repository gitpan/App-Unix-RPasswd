package App::Unix::RPasswd::Connection;

use namespace::autoclean;
use feature ':5.10';
use Moose;
use Expect;

our $VERSION = '0.3';
our $AUTHOR  = 'Claudio Ramirez <nxadm@cpan.org>';

has 'user' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'ssh_args' => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

sub run {
    my ( $self, $server, $new_pass, $debug ) = @_;
    my $success = 0;
    my $exp = Expect->new();
    $exp->raw_pty(1);
    $exp->log_stdout(0) if !$debug;
    $exp->spawn( $self->_construct_cmd($server) )
      or warn 'Cannot change the password of '
      . $self->user
      . "\@$server: $!\n";
    $exp->expect(
        "10",
        [
            qr/password:/i => sub {
                my $exp = shift;
                $exp->send( $new_pass . "\r" );
                exp_continue;
              }
        ]
    );
    $exp->soft_close();
    $success = ( $exp->exitstatus == 0 ) ? 1 : 0;    # shell -> perl status
    if ( $success == 1 ) {
        say "Password changed on $server.";
    }
    else {
        warn "Failed to change the password on $server.\n";
    }
    return $success;
}

sub _construct_cmd {
    my ( $self, $server ) = @_;
    my @command = (
        @{ $self->ssh_args },
        $server, '/usr/bin/passwd', '-r', 'files', $self->user
    );
    return @command;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=pod

=head1 NAME

App::Unix::RPasswd::Connection - Run passwd remotely

=head1 VERSION

Version 0.3

=head1 SYNOPSIS

B<This is an internal module of App::Unix::RPasswd.> 

=head1 AUTHOR

Claudio Ramirez <nxadm@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 Claudio Ramirez.
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut