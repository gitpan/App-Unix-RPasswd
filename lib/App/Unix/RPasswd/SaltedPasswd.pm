package App::Unix::RPasswd::SaltedPasswd;
# This is an internal module of App::Unix::RPasswd

use feature ':5.10';
use Mouse;
use Crypt::PasswdMD5 ('unix_md5_crypt');
use List::MoreUtils  ('zip');

our $VERSION = '0.33';
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

no Mouse;
__PACKAGE__->meta->make_immutable;
1;
