use inc::Module::Install;
  
# Define metadata
name           'App-Unix-RPasswd';
all_from       'lib/App/Unix/RPasswd.pm';
license 		'gpl';
no_index       'directory'   => 'lib/App/Unix/RPasswd';
install_script 'rpasswd';
  
# Specific dependencies
perl_version '5.010000';
requires 'Crypt::PasswdMD5'      => 0;
requires 'Expect'                => 0;
requires 'List::MoreUtils'       => 0;
requires 'Mouse'                 => 0;
requires 'Parallel::ForkManager' => 0;
test_requires  'Test::More'  => '0.42';

WriteAll;
