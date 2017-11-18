# puppet configuration

How is this puppet repository set up?..

## Where do I start with looking in puppet?

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

    modules/elasticsearch
    modules/logrotate
    modules/nginx
    modules/perlbrew

# References

http://www.puppetcookbook.com/

puppetmaster --genconfig
