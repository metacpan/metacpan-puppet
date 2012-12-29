node bm-n2 {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    include metacpan
    include metacpan::exim
    include metacpan::user::admins
    include metacpan::cron::api
    include metacpan::munin

    elasticsearch { "0.20.2": memory  => 18000 }
}
