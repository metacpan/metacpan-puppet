node dev {
    
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

    include munin::web
    include munin-server

}
