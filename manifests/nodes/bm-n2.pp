node bm-n2 {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    # Load all the generic metacpan stuff
    include nginx
    include metacpan

    include metacpan::ssh

    include metacpan::user::admins

    # include metacpan::cron::api


    elasticsearch { "0.20.2":
        memory  => 15000,
    }

    # include munin::web
    # include munin-server
}
