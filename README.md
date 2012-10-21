# metacpan puppet configurations

All machines will be setup identically for now...

# Install Debian stable (6.0.4)
    Base iso from http://www.debian.org/distrib/

# Quick Start

To do the pre-Puppet install in one step, run this command from somewhere other
than /etc/puppet and then skip to the "To Run" section below:

    aptitude install curl
    bash <(curl -s https://raw.github.com/CPAN-API/Metacpan-Puppet/master/init.sh)

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
    update-rc.d -n puppetmaster remove
    update-rc.d -n puppet remove
    update-rc.d -n puppetqd remove

# Setup
    cd /etc
    rm -rf puppet
    git clone git://github.com/CPAN-API/Metacpan-Puppet.git ./puppet

# To Run (start master, run puppet client, stop master)
    /etc/puppet/run.sh dev

You may have to run this a couple of times the first time, the very
first time it will take quite a while to run (it has a lot to do!)
You can also use 'n1' for the live server, others will be added over time

Users have ~/.metacpanrc which they may want to 'source' in their .bash_profile

# Copy http certificates
    Copy /home/metacpan/certs directory from existing machine

# Create or update repositories: www, api and others
    # as 'metacpan' user
    perl ~/bin/update_repos

# Where do I start with looking in puppet?

    # Globals & loading specific modules
    manifests/site.pp

    # Server specific
    manifests/nodes/...

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
