# Define a VCL from a Puppet template
# and load the VCL
#
# If the VCL fails to parse, the exec will fail
# and Varnish will continue to run with the old config
define varnish::vcl (
  $content,
  $file = $name) {

  include varnish
  include varnish::params

  exec { "vcl_reload_$name":
    command     => $varnish::params::vcl_reload,
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
