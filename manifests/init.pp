#
# Class: initscript
#
# Manages an init script.
#
# Usage:
#
class initscript (

  $name,
  $description,
  $binary,
  $user = "root",
  $cmd_options = "",
  $config_file = "",
  $friendly_name = $name,
) {

  file { "/etc/init.d/$name":
      ensure => present,
      mode => "755",
      owner => "root",
      group => "root",
      content => template('initscript/script.rb'),
   }
}
