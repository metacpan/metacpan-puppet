node bm-n2 {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    # Load all the generic metacpan stuff
    include nginx
    include metacpan

    #include metacpan::ssh::server

    include metacpan::user::admins

    # include metacpan::cron::api


    $elasticsearch_memory_mb = 14336
    $es_live_version = '0.20.2'
    include elasticsearch::install

    # include munin::web
    # include munin-server

}
