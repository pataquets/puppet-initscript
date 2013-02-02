class { 'initscript': 
  name => dummyservice,
  description => "A test service for Puppet initscript",
  binary => "/bin/true",
  cmd_options => "-a -p 123",
  config_file => "/etc/foo.conf",
  friendly_name => "Dummy Service",
}
