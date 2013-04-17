# metacpan puppet configurations

All machines will be setup identically for now...

## Using Vagrant for development/testing

For development and/or testing the puppet configuration
[vagrant](http://vagrantup.com) can be very handy.

If you don't have a vagrant base box named "squeeze64"
a suitable one will be downloaded from [vagrantbox.es](http://vagrantbox.es).
It's ~270MB in size, so be prepared.

Then (from the repo root directory):

    vagrant up

To create a virtual machine and provision it
(which includes the steps in 'init.sh').

Then ssh in to your vm and start testing:

    vagrant ssh
    sudo /etc/puppet/run.sh default

Now look at the [final steps](INSTALL_FINALIZING.md)
