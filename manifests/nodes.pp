# Setup all machines the same (for now at least)

$perlbrew_ = 'export PATH=/usr/local/perlbrew/perls/metalib/bin:$PATH'

node localhost {

    $perlbin = '/usr/local/perlbrew/perls/metalib/bin'

    # Load all the generic metacpan stuff
    include metacpan

    # Perl take quite a while, so comment out
    # if your testing other things
    # include metacpan::perl::modules

    include metacpan::ssh::server

    # Choose what we want
    include metacpan::users::basic
    include metacpan::users::admins
    
    include metacpan::website::api
    # include metacpan::cron::api

    include metacpan::website::www
    
    # 14336 = live elasticsearch_memory_mb
    # $elasticsearch_memory_mb = '20'
    include elasticsearch::install

    $vhosts = [ "munin" ]
    include nginx

    include munin::web
    include munin-server
    
}
