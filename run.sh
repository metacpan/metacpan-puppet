#!/bin/sh

find /etc/puppet -type d -exec chmod a+rx {} \;
find /etc/puppet -type f -exec chmod a+r {} \;

/etc/init.d/puppetmaster start
# cd /etc/puppet
#git pull
puppetd -t
/etc/init.d/puppetmaster stop
