#/bin/sh

ssldir=/etc/puppet/ssl

for mnt in $ssldir v-puppet; do
  mount | grep -qE "(^| )${mnt} " && umount "$mnt"
done

# just umount, don't remount
if [ "$1" = "-u" ]; then
  exit
fi

# show a reminder if the shared folder is ever not mounted
echo "Vagrant should mount the repo root over this directory" > /etc/puppet/VAGRANT_SHARE_DIR_NOT_MOUNTED.txt

# Now remount it with root as the owner so puppet works correctly
mount -t vboxsf -o uid=0,gid=0 v-puppet /etc/puppet/

# Mount another fs on top of the share so we can change the owner
# since the 'puppet' user needs to be able to write to the ssl dir
# (but we can't change the owner on a subdir of the vboxsf).
# This way we can keep the same config as production (no vagrant).

mkdir -p $ssldir

ssl_bind_src=/etc/puppet-ssl
mkdir -p $ssl_bind_src
chown puppet:puppet $ssl_bind_src

mount --bind $ssl_bind_src $ssldir

chown -R puppet:puppet $ssldir
