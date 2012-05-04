class metacpan {
    
    # Load in, some of these do stuff, some just mean you
    # can use the sub class from nodes.pp
    include metacpan::ssh
    include metacpan::configs
    include metacpan::users
    include metacpan::cron
    include metacpan::perl
    include metacpan::site
    
}




