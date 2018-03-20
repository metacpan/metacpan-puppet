#WARNING 

This module is now unsupported by Puppetlabs.  It is replaced by the upstream
version at http://forge.puppetlabs.com/jfryman/nginx which is a much improved
version of this module.  It's had many new featured and abilities merged in and
is a true superset of this module.  Please adjust your Modulefile's and other
resources to use it instead.

You can add jfryman's version as a git upstream remote by doing:

$ git remote add jfryman https://github.com/jfryman/puppet-nginx.git
$ git fetch jfryman

You can view a list of release tags at:

https://github.com/jfryman/puppet-nginx/releases

You can then merge his into yours:

$ git merge jfryman v0.0.5
