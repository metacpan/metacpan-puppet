# Puppet munin module [![Build Status](https://travis-ci.org/ssm/ssm-munin.png?branch=master)](https://travis-ci.org/ssm/ssm-munin)

Control munin master, munin node, and munin plugins.

Munin nodes are automatically configured on the master. (Requires
puppetdb)

# Munin master

Typical usage:

    include munin::master

Installs a munin master, and automatically collects configuration from
all munin nodes configured with munin::node.

# Munin node definition

    munin::master::node_definition { 'fqn':
        address => $address,
        config  => ['additional', 'configuration' 'lines'],
    }

The resource title is used as the munin FQN, or "fully qualified
name". This defines the node name and group. It is common to use the
host's fully qualified domain name, where the domain name will be
implicitly used as the node group.

The address is the host name, ip address, or alternate transport used
to contact the node.

To add more configuration, specify it as an array for the "config"
attribute.

For more information about configuring a munin node definition, see
http://munin.readthedocs.org/en/latest/reference/munin.conf.html#node-definitions

If you have multiple munin master servers in your infrastructure and want to assign different nodes to different masters, you can specify the master's fully qualified domain name on the node's definition:

    munin::master::node_definition { 'fqn':
        address    => $address,
        mastername => 'munin.example.com',
    }

## Static node definitions

The munin master class will collect all
"munin::master::node_definition" exported by "munin::node".

For extra nodes, you can define them in hiera, and munin::master will
create them.  Example:

    munin::master::node_definition { 'foo.example.com':
      address => '192.0.2.1'
    }
    munin::master::node_definition { 'bar.example.com':
      address => '192.0.2.1',
      config  => [ 'load.graph_future 30',
                   'load.load.trend yes',
                   'load.load.predict 86400,12' ],
    }

### node definitions as class parameter

If you define your nodes as a data structure in a puppet manifest, or from the
puppet External Node Classifier, you can use a class parameter:

    $nodes = { ... }

    class { 'puppet::master':
      node_definitions => $nodes,
    }

### node definitions with hiera

A JSON definition.

    {
      "munin::master::node_definitions" : {
        "foo.example.com" : {
          "address" : "192.0.2.1"
        },
        "bar.example.com" : {
          "address" : "192.0.2.2",
          "config" : [
            "load.graph_future 30",
            "load.load.trend yes",
            "load.load.predict 86400,12"
          ]
        }
      }
    }


A YAML definition

    ---
    munin::master::node_definitions:
      foo.example.com:
        address: 192.0.2.1
      bar.example.com:
        address: 192.0.2.2
        config:
        - load.graph_future 30
        - load.load.trend yes
        - load.load.predict 86400,12

# Munin node

Typical usage:

    class { 'munin::node':
        allow => [ '192.0.2.0/24', '2001:db8::/64' ]
    }

or in hiera:

    ---
    munin::node::allow:
      - 192.0.2.0/24
      - 2001:db8::/64

Installs munin-node, and exports a munin::master::node_definition
which munin::master will collect, and allows munin masters on
specified networks to connect.

The munin::node class does take more parameters, see the
'manifests/node.pp' file for complete documentation.

# Munin plugins

The defined type munin::plugin is used to control the munin plugins
used on a munin node.

Typical usage:

    munin::plugin { 'cpu':
      ensure => link,
    }

## Examples

### Activate a plugin

Here, we activate an already installed plugin.

The use of "ensure => link" creates an implicit "target =>
/usr/share/munin/plugins/$title".

The "target" parameter can be set to an absolute path (starting with a
"/"), or a relative path (anything else). If relative,
$munin::params::node::plugin_share_dir is prepended to the path.

    munin::plugin {
      'apt':
        ensure => link;
      'something':
        ensure => link,
        target => '/usr/local/share/munin/plugins/something';
      'ip_eth0':
        ensure => link,
        target => 'ip_'; # becomes $munin::params::node::plugin_share_dir/ip_
    }


### Install and activate a plugin

The use of "ensure => present" creates a file in /etc/munin/plugins

    munin::plugin { 'somedaemon':
        ensure => present,
        source => 'puppet:///modules/munin/plugins/somedaemon',
    }

### Activate wildcard plugin

A pair of plugins we provide, with a _name symlink (This is also known
as "wildcard" plugins)

    munin::plugin {
      'foo_bar':
        ensure => present,
        target => 'foo_',
        source => 'puppet:///modules/munin/plugins/foo_';
      'foo_baz':
        ensure => present,
        target => 'foo_',
        source => 'puppet:///modules/munin/plugins/foo_';
    }

### Plugin with configuration

This creates an additional "/etc/munin/plugin-conf.d/${title}.conf"

    munin::plugin {
      'bletch':
        ensure => link,
        config => 'env.database flumpelump';
      'thud':
        ensure => present,
        source => 'puppet:///modules/munin/plugins/thud',
        config => ['env.database zotto', 'user root'];
    }

### A plugin configuration file

This only adds a plugin configuration file.

    munin::plugin { 'slapd':
      config       => ['env.rootdn cn=admin,dc=example,dc=org'],
      config_label => 'slapd_*',
    }
