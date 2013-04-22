$options = ''
class { 'keepalived':
  # Bogus, won't work, this is just for testing...
  content => template('keepalived/sysconfig.erb'),
  options => '-D --vrrp',
}
