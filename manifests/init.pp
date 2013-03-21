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
#  class { 'keepalived':
#    source  => 'puppet:///mymodule/keepalived.conf',
#    options => '-D --vrrp',
#  }
#
class keepalived (
  $content = undef,
  $source  = undef,
  $options = '-D'
) inherits keepalived::params {

  package { $keepalived::params::package: ensure => installed }

  service { $keepalived::params::service:
    enable    => true,
    ensure    => running,
    # "service keepalived status" always returns 0 even when stopped on RHEL
    #hasstatus => true,
    require   => Package[$keepalived::params::package],
  }

  File {
    notify  => Service[$keepalived::params::service],
    require => Package[$keepalived::params::package],
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

  case $keepalived::params::conf {
    'sysconfig': {
      # Configuration for VRRP/LVS disabling
      file { '/etc/sysconfig/keepalived':
        content => template('keepalived/sysconfig.erb'),
      }
    }
    'confd': {
      # Configuration for VRRP/LVS disabling
      file { '/etc/conf.d/keepalived':
        content => template('keepalived/conf.d.erb'),
      }
    }
    false: {}
  }

}

