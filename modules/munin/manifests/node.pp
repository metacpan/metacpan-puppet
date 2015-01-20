# munin::node - Configure a munin node, and export configuration a
# munin master can collect.
#
# Parameters:
#
# allow: List of IPv4 and IPv6 addresses and networks to allow to connect.
#
# config_root: Root directory for munin configuration.
#
# nodeconfig: List of lines to append to the munin node configuration.
#
# host_name: The host name munin node identifies as. Defaults to
# the $::fqdn fact.
#
# log_dir: The log directory for the munin node process. Defaults
# change according to osfamily, see munin::params::node for details.
#
# masterconfig: List of configuration lines to append to the munin
# master node definitinon
#
# mastername: The name of the munin master server which will collect
# the node definition.
#
# mastergroup: The group used on the master to construct a FQN for
# this node. Defaults to "", which in turn makes munin master use the
# domain. Note: changing this for a node also means you need to move
# rrd files on the master, or graph history will be lost.
#
# plugins: A hash used by create_resources to create munin::plugin
# instances.
#
# address: The address used in the munin master node definition.
#
# package_name: The name of the munin node package to install.
#
# service_name: The name of the munin node service.
#
# service_ensure: Defaults to "". If set to "running" or "stopped", it
# is used as parameter "ensure" for the munin node service.
#
# export_node: "enabled" or "disabled". Defaults to "enabled".
# Causes the node config to be exported to puppetmaster.
#
# file_group: The UNIX group name owning the configuration files,
# log files, etc.

class munin::node (
  $address        = $munin::params::node::address,
  $allow          = $munin::params::node::allow,
  $config_root    = $munin::params::node::config_root,
  $host_name      = $munin::params::node::host_name,
  $log_dir        = $munin::params::node::log_dir,
  $masterconfig   = $munin::params::node::masterconfig,
  $mastergroup    = $munin::params::node::mastergroup,
  $mastername     = $munin::params::node::mastername,
  $nodeconfig     = $munin::params::node::nodeconfig,
  $package_name   = $munin::params::node::package_name,
  $plugins        = $munin::params::node::plugins,
  $service_ensure = $munin::params::node::service_ensure,
  $service_name   = $munin::params::node::service_name,
  $export_node    = $munin::params::node::export_node,
  $file_group     = $munin::params::node::file_group,
) inherits munin::params::node {

  validate_array($allow)
  validate_array($nodeconfig)
  validate_array($masterconfig)
  validate_string($mastergroup)
  validate_string($mastername)
  validate_hash($plugins)
  validate_string($address)
  validate_absolute_path($config_root)
  validate_string($package_name)
  validate_string($service_name)
  validate_re($service_ensure, '^(|running|stopped)$')
  validate_re($export_node, '^(enabled|disabled)$')
  validate_absolute_path($log_dir)
  validate_string($file_group)

  if $mastergroup {
    $fqn = "${mastergroup};${host_name}"
  }
  else {
    $fqn = $host_name
  }

  # Defaults
  File {
    ensure => present,
    owner  => 'root',
    group  => $file_group,
    mode   => '0444',
  }

  package { $package_name:
    ensure => installed,
  }

  service { $service_name:
    ensure  => $service_ensure ? {
      ''      => undef,
      default => $service_ensure,
    },
    enable  => true,
    require => Package[$package_name],
  }

  file { "${config_root}/munin-node.conf":
    content => template('munin/munin-node.conf.erb'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  # Export a node definition to be collected by the munin master
  if $export_node == 'enabled' {
    @@munin::master::node_definition{ $fqn:
      address    => $address,
      mastername => $mastername,
      config     => $masterconfig,
      tag        => [ "munin::master::${mastername}" ]
    }
  }

  # Generate plugin resources from hiera or class parameter.
  create_resources(munin::plugin, $plugins, {})

}
