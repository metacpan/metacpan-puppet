#!/bin/sh

while [ -z $goon ]
do
    echo -n 'This script should only be run *before* the initial puppet install. It will wipe out your /etc/puppet Are you really sure you want to do this? (Y/n)'
    read goon
    if [ $goon != 'Y' ]
    then
       exit
    fi
done

# Install some basics
apt-get update
apt-get --assume-yes install vim sudo openssh-server git

# Get puppet repo setup and installed
cd /tmp/
wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
dpkg -i puppetlabs-release-wheezy.deb
apt-get update
apt-get install -y puppet

# We don't want puppet running automatically
service puppet stop
update-rc.d puppet remove

if test -z "$VAGRANT_IS_PROVISIONING"; then

# Clone the latest repo
cd /etc
rm -rf puppet
git clone https://github.com/CPAN-API/metacpan-puppet.git ./puppet
mkdir -p /etc/puppet/files

fi

echo 'Now follow the rest of the steps from:'
echo 'https://github.com/CPAN-API/metacpan-puppet/blob/master/documentation/INSTALL_FINALIZING.md'
