#!/bin/bash

cd /etc/puppet
puppet module list --tree --modulepath modules
