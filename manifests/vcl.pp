# Define a VCL from a Puppet template
# and load the VCL
#
# If the VCL fails to parse, the exec will fail
# and Varnish will continue to run with the old config
define varnish::vcl (
  $content,
  $file = $name,
  $reload = true
) {

  include varnish
  include varnish::params

  if $reload {
    $reload_command = $varnish::params::vcl_reload
  }
  else {
    $reload_command = "/bin/echo 'noop' >> /dev/null"
  }

  exec { "vcl_reload_$name":
    command     => $reload_command,
    refreshonly => true,
  }

  file { $file:
    content => $content,
    notify  => Exec["vcl_reload_$name"],
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['varnish::install'],
  }
}
