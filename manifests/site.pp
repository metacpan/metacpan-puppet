$fileserver = 'puppet://localhost/files'
$moduleserver = 'puppet://localhost'

import 'modules.pp'
import 'classes/*.pp'
import 'metacpan/*.pp'

include 'perlbrew'

case $operatingsystem {
  Debian: {
    Package{ provider => apt }
  }
  default: {
    Package{ provider => apt }
  }
}

# Setup all machines the same (for now at least)
node localhost {
    # classes/base.pp
    include default_setup

    # classes/metacpan/perl.pp
    include metacpan_perl

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
