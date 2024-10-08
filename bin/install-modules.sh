#!/bin/bash

# Brute force Puppet module upgrades

PUPPET="puppet module install --force --modulepath /etc/puppet/contrib-modules"

declare -a arr=("apt" "concat" "firewall" "gcc" "java" "postgresql" "stdlib" "vcsrepo")

for m in "${arr[@]}"
    do
        $PUPPET "puppetlabs-$m"
    done

$PUPPET puppet-archive # puppetlabs-java
$PUPPET elastic-elasticsearch
$PUPPET elastic-elastic_stack # elastic-logstash
$PUPPET puppet-tea # elastic-elasticsearch
$PUPPET richardc-datacat
$PUPPET elastic-logstash
$PUPPET saz-rsyslog
$PUPPET bashtoni-timezone
$PUPPET puppet-logrotate
$PUPPET puppet-yum
