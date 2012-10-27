#!/bin/bash

echo "vagrant provision: $0"

# pizza pizza
dir=/vagrant/vagrant

$dir/make-init-for-vagrant.pl
echo Y | $dir/init-for-vagrant.sh
