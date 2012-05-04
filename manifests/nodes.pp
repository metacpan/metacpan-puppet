# Setup all machines the same (for now at least)
node localhost {

    # Load all the generic metacpan stuff
    include metacpan

    # Perl take quite a while, so comment out
    # if your testing other things
    include metacpan::perl::modules

    include metacpan::ssh::server

    # Choose what we want
    include metacpan::users::basic
    include metacpan::users::admins
    include metacpan::rc_files
    include metacpan::cron::api
    

    include munin::web
    include munin-server
    
    

    $vhosts = [
    "api.metacpan.org", "metacpan.org",
    "sco.metacpan.org", "cpan.metacpan.org", "js.metacpan.org",
    "contest.metacpan.org",
    "munin",
    ]
    include nginx

}
