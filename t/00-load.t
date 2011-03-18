#!perl -T

use Test::More tests => 3;

BEGIN {
    use_ok( 'App::Unix::RPasswd' ) || print "Bail out!";
    use_ok( 'App::Unix::RPasswd::Connection' ) || print "Bail out!";
    use_ok( 'App::Unix::RPasswd::SaltedPasswd' ) || print "Bail out!";
}

diag( "Testing App::Unix::rpasswd $App::Unix::RPasswd::VERSION, Perl $], $^X" );
