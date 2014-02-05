# dev server

node default {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    $apiworkers = 1

    include metacpan
    include metacpan::ssh
    elasticsearch { "0.20.2": }
}
