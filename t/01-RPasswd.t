#!perl -T
use Test::More tests => 2;
use App::Unix::RPasswd;

if ( $ENV{PATH} =~ /(.+)/ ) { $ENV{PATH} = $1; }    # untaint the var
my $rpasswd = App::Unix::RPasswd->new( date => 19700101 );
isa_ok($rpasswd, 'App::Unix::RPasswd');
can_ok( $rpasswd, 'ask_key' );

