# Steps for finalizing an install
# Final steps once server/VM is setup...

# To Run - as root (start master, run puppet client, stop master)
    /etc/puppet/run.sh

You may have to run this a couple of times to get everything setup
correctly. The very first time it will take quite a while to run 
(it has a lot to do!)

Users have ~/.metacpanrc which they may want to 'source' in their .bash_profile

# Copy credentials (including http certificates for the live servers)
    Copy /home/metacpan/credentials directory from existing machine

# Create or update repositories: www, api and others

    sudo /home/metacpan/bin/update_repos

This will also check each repo for prerequisite perl modules and prompt to install.

# Install a Perl module manually

To install specific modules rather than 'everything required by the repo':

    sudo /home/metacpan/bin/install_modules Foo::Bar Fluffy::Bunny ...
