$fileserver = 'puppet://localhost/files'
$moduleserver = 'puppet://localhost'

import 'modules.pp'
import 'classes/*.pp'
import 'metacpan/*.pp'

# Setup all machines the same (for now at least)
node localhost {
        
    # classes/base.pp
    include default_setup
    
    # classes/metacpan/perl.pp
    include metacpan_perl
    
    # Used for cron
    $path_env = 'PATH=/usr/local/perlbrew/perls/metalib/bin:/usr/local/bin:/usr/bin:/bin'
    include cron::website

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
