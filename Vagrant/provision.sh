#!/bin/bash

echo "vagrant provision: $0"

# pizza pizza
dir=/vagrant/Vagrant

# avoid getting prompted about sudoers config conflict
# when init.sh does an apt-get update with backports
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


# run.sh won't run until this is done:
hosts_line="127.0.0.1    puppet"
grep -F "$hosts_line" /etc/hosts || echo $'\n\n# puppet (run.sh)\n'"$hosts_line" >> /etc/hosts


# We need Vagrant to establish the mount point through virtualbox (for -t vboxsf)
# but we need to remount it manually to chown it to root.
# Unmount it here to avoid any side effects of running init.sh
umount v-puppet

# Run a modified init.sh
$dir/make-init-for-vagrant.pl
echo Y | $dir/init-for-vagrant.sh

# Now remount so puppet works correctly
$dir/mount_etc_puppet.sh
