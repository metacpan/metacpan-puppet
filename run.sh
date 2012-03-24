#!/bin/sh

/etc/init.d/puppetmaster start
cd /etc/puppet
#git pull
puppetd -t
/etc/init.d/puppetmaster stop
