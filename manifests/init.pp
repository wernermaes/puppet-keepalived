# Class: keepalived
#
# Install, enable and configure the keepalived VRRP and LVS management daemon.
#
# Parameters:
#  $content:
#    File content for keepalived.conf. Default: none
#  $source:
#    File source for keepalived.conf. Default: none
#  $options:
#    Command-line options to keepalived. Default: -D
#
# Sample Usage :
#  class { '::keepalived':
#    source  => 'puppet:///mymodule/keepalived.conf',
#    options => '-D --vrrp',
#  }
#
class keepalived (
  $content        = undef,
  $source         = undef,
  $options        = '-D',
  $service_enable = true,
  $service_ensure = 'running',
  $package_ensure = 'installed',
) inherits ::keepalived::params {

  package { $::keepalived::params::package: ensure => $package_ensure }

  service { $::keepalived::params::service:
    enable  => $service_enable,
    ensure  => $service_ensure,
    require => Package[$::keepalived::params::package],
  }

  File {
    notify  => Service[$::keepalived::params::service],
    require => Package[$::keepalived::params::package],
  }

  # Optionally managed main configuration file
  if $content or $source {
    file { "${confdir}/keepalived.conf":
      content => $content,
      source  => $source,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  $sysconfdir = $::keepalived::params::sysconfdir
  if $sysconfdir == 'sysconfig' or $sysconfdir == 'conf.d' {
    # Configuration for VRRP/LVS disabling
    file { "/etc/${sysconfdir}/keepalived":
      content => template("keepalived/${sysconfdir}.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

}

