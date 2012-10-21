#!/bin/sh

find /etc/puppet -type d -exec chmod a+rx {} \;
find /etc/puppet -type f -exec chmod a+r {} \;

cd /etc/puppet

# Aways specify the fqdn so we get the right config
if [ ! $1 ]
then
	echo "Must supply a node type arg (dev, testing, n1, n2..)"
	exit;
fi

# First run we need a default for the master to work inc autosign
if [ ! -f "/etc/puppet/puppet.conf" ]
then
	cp /etc/puppet/puppet.conf.default /etc/puppet/puppet.conf
fi

/etc/init.d/puppetmaster start

#git pull
puppetd -t --certname=$1
/etc/init.d/puppetmaster stop
