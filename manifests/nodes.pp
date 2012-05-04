# Setup all machines the same (for now at least)
node localhost {
        
    # classes/base.pp
    include default_setup
    
    # classes/metacpan/perl.pp
    # include metacpan_perl
    
    # Used for cron
    # include cron::website

    include munin::web
    include munin-server

    include metacpan
    include metacpan::users::basic
    include metacpan::users::admins

    # include metacpan::perl
    include metacpan::rc_files
    include metacpan::cron::api

    $vhosts = [
    "api.metacpan.org", "metacpan.org",
    "sco.metacpan.org", "cpan.metacpan.org", "js.metacpan.org",
    "contest.metacpan.org",
    "munin",
    ]
    include nginx

}
