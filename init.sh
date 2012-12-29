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

aptsource="deb http://backports.debian.org/debian-backports squeeze-backports main"
aptlists=/etc/apt/sources.list
test -d $aptlists.d && aptlistsdir=$aptlists.d
if ! grep -q -R -F "$aptsource" $aptlists $aptlistsdir; then
  if [ $aptlistsdir ]; then
    echo "$aptsource" >> $aptlistsdir/backports.list
  else
    echo "$aptsource" >> $aptlists
  fi
fi

apt-get update

apt-get --assume-yes install vim sudo openssh-server git
apt-get --assume-yes -t squeeze-backports install puppetmaster puppet

# We don't want puppet running automatically
update-rc.d -n puppetmaster remove
update-rc.d -n puppet remove
update-rc.d -n puppetqd remove

if test -z "$VAGRANT_IS_PROVISIONING"; then

cd /etc
rm -rf puppet
git clone https://github.com/CPAN-API/Metacpan-Puppet.git ./puppet
mkdir -p /etc/puppet/files

fi

echo 'Now follow the rest of the steps from:'
echo 'https://github.com/CPAN-API/Metacpan-Puppet#to-run-start-master-run-puppet-client-stop-master'
