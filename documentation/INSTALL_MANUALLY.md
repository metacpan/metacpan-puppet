# Installing a server manually

We strongly recommend using [vagrant setup](INSTALL_VAGRANT.md) for all testing or development machines.

# Install Debian stable (6.0.4)
    Base iso from http://www.debian.org/distrib/

# Setup puppet

To do the pre-Puppet install in one step, run this command from somewhere other
than /etc/puppet and then skip to the "To Run" section below:

    aptitude install curl
    bash <(curl -s https://raw.github.com/CPAN-API/metacpan-puppet/master/init.sh)

If you prefer not to run the script above, continue on below.

# We want puppet from backports so...
    # Edit /etc/apt/sources.list add:
    deb http://backports.debian.org/debian-backports squeeze-backports main

# Now install the minimum to get puppet running

To follow the steps manually, copy/paste the commands belo

    apt-get update

    apt-get install openssh-server git
    apt-get -t squeeze-backports install puppetmaster puppet

Should get you puppet 2.7.14 (which fixes a issue with update-rc.d)

    # We don't want puppet running automatically
    update-rc.d puppetmaster remove
    update-rc.d puppet remove
    update-rc.d puppetqd remove

# Setup
    cd /etc
    rm -rf puppet
    git clone git://github.com/CPAN-API/metacpan-puppet.git ./puppet

Now look at the [final steps](INSTALL_FINALIZING.md)
