Repo for metacpan server puppet configurations

All machines will be setup identically.

OpenSuse:

# Installing
    zypper in puppet-server

Should get you puppet-0.25.4-4.7.1.x86_64

# Setup
    cd /etc
    rm -rf puppet
    git clone git://github.com/CPAN-API/Metacpan-Puppet.git ./puppet

# To Run
    /etc/init.d/puppetmasterd start
    puppetd -t
    /etc/init.d/puppetmasterd stop

# To test
    rm /tmp/leo_testing.txt
Then follow 'To Run' above and this file will be recreated.


