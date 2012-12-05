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

ssldisk=/etc/puppet-ssl.disk
if ! test -e $ssldisk; then
  # build a 10MB disk for the ssl certs so it can be mounted as another user
  dd if=/dev/zero of=$ssldisk bs=1K count=10K
  yes | mke2fs -q $ssldisk > /dev/null
  chown puppet $ssldisk
fi

mkdir -p $ssldir
chown -R puppet:puppet $ssldir

# mount this disk over the shared folder mount so we can change the owner
mount -o loop $ssldisk $ssldir
chown -R puppet:puppet $ssldir
