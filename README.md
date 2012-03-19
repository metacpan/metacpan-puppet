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

# To Run (start master, cd, git pull, puppet, stop master)
    /etc/puppet/run.sh

# To test
    rm /tmp/puppet_testing.txt
Then follow 'To Run' above and this file will be recreated.

# References

http://www.puppetcookbook.com/

# Do not need
   gem install puppet-module

# To configure

*  nginx
*  munin-node
*  munin (master, including cron)
*  users, including ssh keys
*  hosts file
*  ES?

ln -s ~metacpan/perl5/perlbrew/perls/perl-5.14.0/bin/perl ~metacpan/perl5/perlbrew/perl

5 0 * * * ~/perl5/perlbrew/perl ~/api.metacpan.org/bin/metacpan release --skip --age 25 --latest ~/CPAN/authors/id/

* make sure this is running.. /etc/init.d/metacpan-watcher start                 
                 

