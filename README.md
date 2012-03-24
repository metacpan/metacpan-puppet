# metacpan puppet configurations

All machines will be setup identically.

Debian stable (6.0.4):

# Install from base iso http://www.debian.org/distrib/
    apt-get install openssh-server git
    apt-get install puppetmaster puppet

Should get you puppet 2.6.2

update-rc.d -n puppetmaster remove
update-rc.d -n puppet remove
update-rc.d -n puppetqd remove

# Setup
    cd /etc
    rm -rf puppet
    git clone git://github.com/CPAN-API/Metacpan-Puppet.git ./puppet

# To Run (start master, cd, git pull, puppet, stop master)
    /etc/puppet/run.sh

# To test
    rm /tmp/puppet_testing.txt
Then follow 'To Run' above and this file will be recreated.

# References

http://www.puppetcookbook.com/
                 
puppetmaster --genconfig
