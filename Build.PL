use strict;
use warnings;
use inc::latest 'Module::Build';

my $builder = Module::Build->new(
    module_name       => 'App::Unix::RPasswd',
    license           => 'gpl',
    dist_author_from  => 'lib/App/Unix/RPasswd.pm',
    dist_version_from => 'lib/App/Unix/RPasswd.pm',
    build_requires    => {
        'Test::More'    => 0,
    },
    requires => {
        'perl'                  => '5.10.0',
        'Crypt::PasswdMD5'      => 0,
        'DateTime'              => 0,
        'Expect'                => 0,
        'File::Basename'        => 0,
        'Getopt::Long'          => 0,
        'List::MoreUtils'       => 0,
        'Moose'                 => 0,
        'namespace::autoclean'  => 0,
        'Parallel::ForkManager' => 0,
    },
    add_to_cleanup     => ['App-Unix-RPasswd-*'],
    create_makefile_pl => 'traditional',
    script_files       => { 'script/rpasswd' => 'bin/rpasswd', },
);

if ( !$builder->is_windowsish() ) {
    my $shebang = '#!' . $builder->perl();
    my @args = ( "-i", "-ple", 's@^#!.+@' . $shebang . '@ if $. == 1',
        'script/rpasswd' );
    $builder->do_system( $builder->perl(), @args ) or die($!);
}

$builder->add_build_element('script');
$builder->create_build_script();
