# metacpan puppet configuration

This repo is for building and running the [metacpan.org](https://metacpan.org) development, test and live servers

## Options

1. [Virtual machine](https://github.com/CPAN-API/metacpan-developer) - strongly recommend for development and testing.

2. [Manual instructions](documentation/INSTALL_MANUALLY.md) - for new live servers

## Repository setup

There is [puppet documentation](documentation/puppet_setup.md)
which shows a very rough outline of how things are setup

## Adding new users

1. Add the new user to modules/metacpan/manifests/user.pp

2. Add the user's pub key to the appropriate folder in
   modules/metacpan/files/default/home

3. After puppet has been run, the new user can SSH in to the production machine
   using hostname bm-n2.metacpan.org and port 2202
