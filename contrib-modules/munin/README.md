# Puppet module ssm-munin #

[![Puppet Forge](http://img.shields.io/puppetforge/v/ssm/munin.svg)](https://forge.puppetlabs.com/ssm/munin)
[![Build Status](https://travis-ci.org/ssm/ssm-munin.png?branch=master)](https://travis-ci.org/ssm/ssm-munin)

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [Puppet module ssm-munin](#puppet-module-ssm-munin)
- [Overview](#overview)
- [Module Description](#module-description)
- [Setup](#setup)
    - [Setup requirements](#setup-requirements)
- [Usage](#usage)
    - [munin::node](#muninnode)
    - [munin::master](#muninmaster)
    - [munin::master::node_definition](#muninmasternodedefinition)
    - [munin::plugin](#muninplugin)
- [Examples](#examples)
    - [munin::master::node_definition](#muninmasternodedefinition)
        - [Static node definitions](#static-node-definitions)
        - [node definitions as class parameter](#node-definitions-as-class-parameter)
        - [node definitions with hiera](#node-definitions-with-hiera)
    - [munin::node](#muninnode)
        - [Allow remote masters to connect](#allow-remote-masters-to-connect)
    - [munin::plugin](#muninplugin)
        - [Activate a plugin](#activate-a-plugin)
        - [Install and activate a plugin](#install-and-activate-a-plugin)
        - [Activate wildcard plugin](#activate-wildcard-plugin)
        - [Plugin with configuration](#plugin-with-configuration)
        - [A plugin configuration file](#a-plugin-configuration-file)

<!-- markdown-toc end -->

# Overview #

Configure munin master, node and plugins.


# Module Description #

This module installs the munin master using the **munin::master**
class, munin node using the **munin::node** class, and can install,
configure and manage munin plugins using the **munin::plugin** defined
type.

Munin nodes are automatically exported by the munin nodes, and
collected on the munin master. (Requires puppetdb)

# Setup #

Classify all nodes with **munin::node**, and classify at least one
node with **munin::master**. Use the **munin::plugin** defined type to
control plugin installation and configuration.


## Setup requirements ##

Munin should be available in most distributions.  For RedHat OS
Family, you need to install the EPEL source.

The **munin::master** class does not manage any web server
configuration.  The munin package installed might add some.


# Usage #

## munin::node ##

Typical usage

    include munin::node

Installs a munin node.

By default, **munin::node** exports a munin node definition so a node
classified with the **munin::master** class can collect it.

Parameters for exporting a munin node definition

* **address**: The address used in the munin master node definition.

* **export_node**: "enabled" or "disabled". Defaults to "enabled".
  Causes the node config to be exported to puppetmaster.

* **masterconfig**: List of configuration lines to append to the munin
  master node definitinon

* **mastername**: The name of the munin master server which will
  collect the node definition.

* **mastergroup**: The group used on the master to construct a FQN for
  this node. Defaults to "", which in turn makes munin master use the
  domain. Note: changing this for a node also means you need to move
  rrd files on the master, or graph history will be lost.

Parameters for the munin node service and configuration

* **allow**: List of IPv4 and IPv6 addresses and networks to allow to
  connect.

* **bind_address**: The IP address the munin-node process listens
  on. Defaults: *.

* **bind_port**: The port number the munin-node process listens on.

* **config_root**: Root directory for munin configuration.

* **host_name**: The host name munin node identifies as. Defaults to
  the $::fqdn fact.

* **log_dir**: The log directory for the munin node process. Defaults
  change according to osfamily, see munin::params::node for details.

* **log_file**: Appended to "log_dir". Defaults to "munin-node.log".

* **log_destination**: "file" or "syslog".  Defaults to "file".  If
  log_destination is "syslog", the "log_file" and "log_dir" parameters
  are ignored, and the "syslog_*" parameters are used if set.

* **purge_configs**: Removes all other munin plugins and munin plugin
  configuration files.  Boolean, defaults to false.

* **syslog_facility**: Defaults to undef, which makes munin-node use
  the perl Net::Server module default of "daemon". Possible values are
  any syslog facility by number, or lowercase name.

* **plugins**: A hash used by create_resources to create munin::plugin
  instances.

* **package_name**: The name of the munin node package to install.

* **service_name**: The name of the munin node service.

* **service_ensure**: Defaults to "". If set to "running" or
  "stopped", it is used as parameter "ensure" for the munin node
  service.

* **file_group**: The UNIX group name owning the configuration files,
  log files, etc.

* **timeout**: Used to set the global plugin runtime timeout for this
  node. Integer. (optional, no default)

* **nodeconfig**: Array of extra configuration lines to append to the
  munin node configuration. (optional, no default)


## munin::master ##

Typical usage:

    include munin::master

Installs a munin master.

By default, **munin::master** collects all munin node definitions
exported by nodes classified with **munin::node**/

Parameters for collecting and defining munin nodes

* **collect_nodes**: 'enabled' (default), 'disabled', 'mine' or
'unclaimed'. 'enabled' makes the munin master collect all exported
node\_definitions. 'disabled' disables it. 'mine' makes the munin
master collect nodes matching **$munin::master::host_name**, while
'unclaimed' makes the munin master collect nodes not tagged with a
host name.

* **host_name**: A host name for this munin master, matched with
munin::node::mastername for collecting nodes. Defaults to $::fqdn

* **node_definitions**: A hash of node definitions used by
create_resources (optional, default: {})

Parameters for the munin master configuration

* **config_root**: the root directory of the munin master
configuration.  (Default is "/etc/munin" on most platforms).

* **dbdir**: Path to the munin dbdir, where munin stores everything

* **graph_strategy**: 'cgi' (default) or 'cron' Controls if
munin-graph graphs all services ('cron') or if graphing is done by
munin-cgi-graph (which must configured seperatly)

* **htmldir**: Path to where munin will generate HTML documents and
graphs, used if graph_strategy is cron.

* **html_strategy**: 'cgi' (default) or 'cron' Controls if munin-html
will recreate all html pages every run interval ('cron') or if html
pages are generated by munin-cgi-graph (which must configured
seperatly)

* **rundir**: Path to directory munin uses for pid and lock files.

* **tls**: 'enabled' or 'disabled' (default). Controls the use of TLS
globally for master to node communications.

* **tls_certificate**: Path to a file containing a TLS certificate. No
default. Required if tls is enabled.

* **tls_private_key**: Path to a file containing a TLS key. No
default.  Required if tls is enabled.

* **tls_verify_certificate**: 'yes' (default) or 'no'.

* **extra_config**: Extra lines of config to put in munin.conf.

## munin::master::node_definition ##

Typical usage:

    munin::master::node_definition { 'fqn':
        address => $address,
        config  => ['additional', 'configuration' 'lines'],
    }

This will add configuration for the munin master to connect to a munin
node, and ask for data from its munin plugins.

Note: By default, the node classified with **munin::master** will
collect all all exported instances of this type from hosts classified
with **munin::node**.

The resource title is used as the munin FQN, or "fully qualified
name". This defines the node name and group. It is common to use the
host's fully qualified domain name, where the domain name will be
implicitly used as the node group.

Parameters

* **address**: The address of the munin node. A hostname, an IP
address, or a ssh:// uri for munin-async node. (**required**, no
default)

* **mastername**: The name of the munin master server which will
collect the node definition. (**optional**, no default)

* **config**: An array of configuration lines to be added to the node
definition. (**optional**, no default)

For more information about configuring a munin node definition, see
http://munin.readthedocs.org/en/latest/reference/munin.conf.html#node-definitions

If you have multiple munin master servers in your infrastructure and
want to assign different nodes to different masters, you can specify
the master's fully qualified domain name on the node's definition:

    munin::master::node_definition { 'fqn':
        address    => $address,
        mastername => 'munin.example.com',
    }


## munin::plugin ##

The defined type munin::plugin is used to control the munin plugins
used on a munin node.

Typical usage:

    munin::plugin { 'cpu':
      ensure => link,
    }

Parameters:

* **ensure**: "link", "present", "absent" or "". (optional, default is
""). The ensure parameter is mandatory for installing a plugin, and
interacts with the **source** and **target** parameters (see below).

* **source**: when ensure => present, source file. (optional)

* **target**: when ensure => link, link target.  If target is an
absolute path (starts with "/") it is used directly.  If target is a
relative path, $munin::node::plugin_share_dir is prepended. (optional)

* **config**: array of lines for munin plugin config

* **config_label**: label for munin plugin config

When using "**ensure** => link", a symlink is created from
/etc/munin/plugins/$title to what the optional **target** parameter
contains, or to /usr/share/munin/plugins/$title if that is not set.

When using "**ensure** => present", you need to provide the **source**
parameter as well.

When **ensure** is not set, a plugin will not be installed, but extra
plugin configuration can be managed with the **config** and
**config_label** parameters.

# Examples #

## munin::master::node_definition ##


### Static node definitions ###

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


### node definitions as class parameter ###

If you define your nodes as a data structure in a puppet manifest, or from the
puppet External Node Classifier, you can use a class parameter:

    $nodes = { ... }

    class { 'puppet::master':
      node_definitions => $nodes,
    }


### node definitions with hiera ###

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

## munin::node ##

### Allow remote masters to connect ###

The **allow** parameter enables the munin master to connect.  By
default, the munin node only permits connections from localhost.

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


## munin::plugin ##

### Activate a plugin ###

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


### Install and activate a plugin ###

The use of "ensure => present" creates a file in /etc/munin/plugins

    munin::plugin { 'somedaemon':
        ensure => present,
        source => 'puppet:///modules/munin/plugins/somedaemon',
    }

### Activate wildcard plugin ###

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

### Plugin with configuration ###

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

### A plugin configuration file ###

This only adds a plugin configuration file.

    munin::plugin { 'slapd':
      config       => ['env.rootdn cn=admin,dc=example,dc=org'],
      config_label => 'slapd_*',
    }
