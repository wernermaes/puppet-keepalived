# This is a simple wrapper class for typical VRRP only keepalived setups.
#
# See README for a complete example, or look at the template to know all
# supported `$config_hash` parameters.
#
class keepalived::vrrp (
  $instances,
  $scripts              = {},
  $global_defs          = {},
  $global_defs_defaults = {},
  $service_ensure       = 'running',
  $service_enable       = true,
  $template_module      = $module_name,
  $template_dir         = '/',
  $template             = 'keepalived-vrrp.conf.erb',
) {

  $global_defs_final = merge($global_defs_defaults,$global_defs)
if $instances.type == Hash {
  $instances_normalized = $instances.values
} else {
  $instances_normalized = $instances
}
  
  class { '::keepalived':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    content        => template("${template_module}${template_dir}${template}"),
    options        => '-D --vrrp',
    instances      => $instances_normalized,
  }

}
