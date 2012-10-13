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

echo "deb http://backports.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list
apt-get update

apt-get --assume-yes install vim sudo openssh-server git
apt-get --assume-yes -t squeeze-backports install puppetmaster puppet

# We don't want puppet running automatically
update-rc.d -n puppetmaster remove
update-rc.d -n puppet remove
update-rc.d -n puppetqd remove

cd /etc
rm -rf puppet
git clone git://github.com/CPAN-API/Metacpan-Puppet.git ./puppet

echo 'Now follow the rest of the steps from:'
echo 'https://github.com/CPAN-API/Metacpan-Puppet#get-all-accounts-to-update-their-passwords-when-login-via-sshkey'