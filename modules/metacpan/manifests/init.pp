class metacpan {
    $perl = "perl-5.16.2"    
    include metacpan::packages
    metacpan::user { metacpan: }
    metacpan::perl {  $perl: }
    include metacpan::rrrclient
    include metacpan::exim
    # Load in, some of these do stuff, some just mean you
    # can use the sub class from nodes.pp
    include metacpan::ssh
#    include metacpan::configs
    include metacpan::cron
    include metacpan::web
}
