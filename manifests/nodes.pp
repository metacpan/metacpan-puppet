# Setup all machines the same (for now at least)
node localhost {

    $metacpanrc = '/home/metacpan/.metacpanrc'
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
    
    include elasticsearch::install

    $vhosts = [ "munin" ]
    include nginx

    include munin::web
    include munin-server
    
}
