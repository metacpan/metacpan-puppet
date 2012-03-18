# metacpan puppet configurations

All machines will be setup identically.

OpenSuse:

# Installing
    zypper in puppet-server
    zypper install rubygems
    yast -i yum

Should get you puppet-0.25.4-4.7.1.x86_64

# Make sure puppet and puppetmaster won't start on reboot
    chkconfig | grep puppet

Turn off with

    hkconfig puppetmaster off

# Setup
    cd /etc
    rm -rf puppet
    git clone git://github.com/CPAN-API/Metacpan-Puppet.git ./puppet

# To Run
    /etc/init.d/puppetmasterd start
    puppetd -t
    /etc/init.d/puppetmasterd stop

# To test
    rm /tmp/puppet_testing.txt
Then follow 'To Run' above and this file will be recreated.

# References

http://www.puppetcookbook.com/

# Do not need
   gem install puppet-module

