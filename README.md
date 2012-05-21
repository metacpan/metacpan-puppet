# metacpan puppet configurations

All machines will be setup identically for now...

Debian stable (6.0.4):

# We want some stuff from backports...
    # Edit /etc/apt/sources.list add:
    deb http://backports.debian.org/debian-backports squeeze-backports main
    
    # Then from command line run
    apt-get update

# Install from base iso http://www.debian.org/distrib/
    apt-get install openssh-server git
    apt-get -t squeeze-backports install puppetmaster puppet

Should get you puppet 2.7.14 (which fixes a issue with update-rc.d)

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

# Where do I start with looking in puppet?

    # Globals & loading specific modules
    manifests/site.pp

    # Server specific (at the moment all servers are localhost)
    manifests/nodes.pp

    # core metacpan stuff is in here
    modules/metacpan/

    # default loader (which loads everything else)
    modules/metacpan/manifests/init.pp

    # static files and templates are in
    modules/metacpan/files or modules/metacpan/templates
    
    # Other modules that get used, these are customised
    modules/munin
    modules/elasticsearch
    modules/logrotate
    modules/nginx
    modules/perlbrew
    
# References

http://www.puppetcookbook.com/
                 
puppetmaster --genconfig

# Notes

5550 to 5559 ports to play with on test box