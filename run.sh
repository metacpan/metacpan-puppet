#!/bin/sh

find /etc/puppet -type d -exec chmod a+rx {} \;
find /etc/puppet -type f -exec chmod a+r {} \;

# Make sure puppet is in our hosts file (on the local machine)
if ! grep -q puppet "/etc/hosts"
then
	echo "Add the following line to your /etc/hosts file then re-run:"
	echo "127.0.0.1    puppet"
	exit
fi

cd /etc/puppet

# Aways specify the cername so we get the right config
# the arg should really exist in the autosign.conf if possible
if [ ! $1 ]
then
	echo "Supply a node arg (dev, or one of the live machines: n1, n2..)"
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
