# Class: keepalived::params
#
# Parameters for the keepalived module.
#
class keepalived::params {
  # The easy bunch
  $service = 'keepalived'
  $confdir = '/etc/keepalived'
  # package & sysconfig presence
  case $::operatingsystem {
    'Gentoo': { $package = 'sys-cluster/keepalived' }
     default: { $package = 'keepalived' }
  }
  # sysconfig presence
  case $::operatingsystem {
    'Fedora',
    'RedHat',
    'CentOS': { $conf = 'sysconfig' }
    'Gentoo': { $conf = 'confd' }
     default: { $conf = false }
  }
}
