node n1 {

    $perlbin = '/usr/local/perlbrew/perls/metalib/bin'

    # Load all the generic metacpan stuff
    include metacpan

    include metacpan::ssh

    # Choose what we want
    include metacpan::user::admins

    include metacpan::website::api
    # include metacpan::cron::api

    include metacpan::website::www

    elasticsearch { "0.20.2": }

    $vhosts = [ "munin" ]
    include nginx

    # Don't enable munin on dev machines
    # include munin::web
    # include munin-server

}
