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
    
    include metacpan::site::api
    include metacpan::cron::api    

    include metacpan::site::web

    include munin::web
    include munin-server
    
    

    $vhosts = [
    "api.metacpan.org", "metacpan.org",
    "sco.metacpan.org", "cpan.metacpan.org", "js.metacpan.org",
    "contest.metacpan.org",
    "munin",
    ]
    include nginx

}
