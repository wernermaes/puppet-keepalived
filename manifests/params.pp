# Class: keepalived::params
#
# Parameters for the keepalived module.
#
class keepalived::params {

  $service = 'keepalived'
  $confdir = '/etc/keepalived'

  # We can't use osfamily since Gentoo's is 'Linux'
  case $::operatingsystem {
    'Gentoo': {
      $package    = 'sys-cluster/keepalived'
      $sysconfdir = 'conf.d'
    }
    'RedHat','Fedora','CentOS','Scientific','Amazon': {
      $package    = 'keepalived'
      $sysconfdir = 'sysconfig'
    }
    default: {
      $package    = 'keepalived'
      $sysconfdir = undef
    }
  }

}
