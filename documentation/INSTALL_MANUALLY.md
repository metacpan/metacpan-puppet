# Installing a server manually

We strongly recommend using our [Virtual machine](https://github.com/metacpan/metacpan-developer) for all testing or development machines.

# Install Debian stable (7.6)
    Base iso from http://www.debian.org/distrib/

# Set up puppet

To do the pre-Puppet install in one step, run this command from somewhere other
than /etc/puppet and then skip to the "To Run" section below:

    aptitude install curl
    bash <(curl -s https://raw.github.com/metacpan/metacpan-puppet/master/init.sh)

You should of course go and read the script first!

Now look at the [final steps](INSTALL_FINALIZING.md)
