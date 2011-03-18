package App::Unix::RPasswd::SaltedPasswd;

use namespace::autoclean;
use feature ':5.10';
use Moose;
use Crypt::PasswdMD5 ('unix_md5_crypt');
use List::MoreUtils  ('zip');

our $VERSION = '0.3';
our $AUTHOR  = 'Claudio Ramirez <nxadm@cpan.org>';

has 'salt' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub generate {
    my ($self, $base_password)   = @_;
    my $passwd = $self->_encode_string(
        unix_md5_crypt( $base_password, $self->salt ) );
    return $passwd;
}

sub _encode_string {
    my ( $self, $opasswd ) = @_;
    $opasswd =~ tr/ /./;
    $opasswd =~ s/\$//g;
    my @array1  = split( //, $opasswd );
    my @array2  = reverse @array1;
    my @array3  = zip( @array2, @array1 );
    my $npasswd = join( '', @array3 );
    my $offset  = ( length $npasswd ) / 2 + 3;
    my $passwd  = substr( $npasswd, $offset, 12 );
    return reverse $passwd;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1; 

__END__

=pod

=head1 NAME

App::Unix::RPasswd::SaltedPasswd - Generate retrievable 'random' passwords 
with a salt

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