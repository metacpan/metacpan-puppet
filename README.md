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
    You may have to run this a couple of times the first time
    
# Get all accounts to update their passwords when login (via sshkey)
    chage -d 0 mo
    chage -d 0 clinton
    chage -d 0 olaf
    chage -d 0 rafl
    chage -d 0 leo
    
Users have ~/.metacpanrc which they may want to 'source' in their .bash_profile

# Copy /home/metacpan/certs directory from existing machine

# as 'metacpan' user
perl ~/bin/update_repos

# To test
    rm /tmp/puppet_testing.txt
Then follow 'To Run' above and this file will be recreated.



# References

http://www.puppetcookbook.com/
                 
puppetmaster --genconfig

# Notes

5550 to 5559 ports to play with on test box