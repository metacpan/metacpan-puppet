#!/bin/sh

/etc/init.d/puppetmasterd start
cd /etc/puppet
git pull
puppetd -t
/etc/init.d/puppetmasterd start
