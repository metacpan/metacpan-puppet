#!/bin/bash

echo "vagrant provision: $0"

# pizza pizza
dir=/vagrant/Vagrant

# avoid getting prompted about sudoers config conflict
v_sudoers=/etc/sudoers.d/vagrant
if ! test -e "$v_sudoers"; then
  echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant
  chmod 0440 "$v_sudoers"

  # revert /etc/sudoers to the original so that backports will update without conflict
  apt-get -y remove sudo
  rm /etc/sudoers
  apt-get -y install sudo

  # this should be present, but just in case
  incd='#includedir /etc/sudoers.d'
  grep -F "$incd" /etc/sudoers ||
    echo "$incd" >> /etc/sudoers
fi

$dir/make-init-for-vagrant.pl
echo Y | $dir/init-for-vagrant.sh
