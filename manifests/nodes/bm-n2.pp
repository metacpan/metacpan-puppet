node bm-n2 {

    $perlbin = '/usr/local/perlbrew/perls/metalib/bin'

    # Load all the generic metacpan stuff
    #include metacpan

    #include metacpan::ssh::server

    # Choose what we want
    #include metacpan::user::admins

    #include metacpan::website::api
    # include metacpan::cron::api

    #include metacpan::website::www

    # 14336 = live elasticsearch_memory_mb
    $elasticsearch_memory_mb = 14336
    $es_live_version = '0.20.2'
    include elasticsearch::install

    #$vhosts = [ "munin" ]
    #include nginx

    # Don't enable munin on dev machines
    # include munin::web
    # include munin-server

}
