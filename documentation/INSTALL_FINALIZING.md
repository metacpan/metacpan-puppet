# Steps for finalizing an install
# Final steps once server/VM is setup...

To Run (start master, run puppet client, stop master)
    /etc/puppet/run.sh dev

You may have to run this a couple of times to get everything setup
correctly (e.g. you have to add lines to /etc/hosts), the very
first time it will take quite a while to run (it has a lot to do!)
You can also use 'n1' for the live server, others will be added over time

Users have ~/.metacpanrc which they may want to 'source' in their .bash_profile

# Copy http certificates (for the live servers)
    Copy /home/metacpan/certs directory from existing machine

# Create or update repositories: www, api and others
    # as 'metacpan' user
    perl ~/bin/update_repos

# INSTALL PERL MODULES...

