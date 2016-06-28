# metacpan puppet configuration

This repo is for building and running the [metacpan.org](https://metacpan.org) development, test and live servers

## Options

1. [Virtual machine](https://github.com/metacpan/metacpan-developer) - strongly recommend for development and testing.

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

## How hiera works:
```
21:20 < ranguard> https://github.com/metacpan/metacpan-puppet/blob/leo/puppet3/modules/facts/lib/facter/env.rb -
                  to set an 'env' value
21:21 < ranguard> https://github.com/metacpan/metacpan-puppet/blob/leo/puppet3/hiera.yaml sets the order config
                  files should be examined ( top overlaying data in the ones below )
21:21 < ranguard> so common.yaml is the ground work, but there are customisations in:
                  https://github.com/metacpan/metacpan-puppet/blob/leo/puppet3/hieradata/env/productions.yaml
21:22 < ranguard> ^^ that is for all production servers
21:22 < ranguard> https://github.com/metacpan/metacpan-puppet/blob/leo/puppet3/hieradata/nodes/bm-mc-02.yaml would
                  be specifically for bm-mc-02 node
21:23 < ranguard> the config files are EVERYTHING, there should be no specific logic in modules, they become dumb
21:25 < ranguard> https://github.com/metacpan/metacpan-puppet/tree/leo/puppet3/manifests/site.pp is called, which
                  loads nodes/*.pp...
21:25 < ranguard> https://github.com/metacpan/metacpan-puppet/blob/leo/puppet3/manifests/nodes/bm.pp - says if the
                  hostname matches 'bm' then run a specific role and the rest comes from hiera
```
