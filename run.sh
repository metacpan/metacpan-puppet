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
CERTNAME=$1
if [ ! $CERTNAME ]
then
    CERTNAME=$(hostname -s)
    echo "Assuming node $CERTNAME"
    echo "Supply a node arg to override -- not required for vagrant (use n1 or n2 for one of the live machines)"
fi

# First run we need a default for the master to work inc autosign
if [ ! -f "/etc/puppet/puppet.conf" ]
then
    cp /etc/puppet/puppet.conf.default /etc/puppet/puppet.conf
fi

/etc/init.d/puppetmaster start

#git pull
puppetd -t --certname=$CERTNAME
/etc/init.d/puppetmaster stop
