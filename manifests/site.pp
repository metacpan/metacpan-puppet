$fileserver = 'puppet://localhost/files'
$moduleserver = 'puppet://localhost'

import 'modules.pp'
import 'classes/*.pp'

case $operatingsystem {
  Debian: {
    Package{ provider => apt }
  }
  default: {
    Package{ provider => apt }
  }
}

node localhost {
    # Setup all machines the same (for now at least)
    include default_setup

    include munin::web
    include munin-server

    $vhosts = [
    "api.metacpan.org", "metacpan.org",
    "sco.metacpan.org", "cpan.metacpan.org", "search.metacpan.org",
    "contest.metacpan.org",
    "munin",
    ]
    include nginx

}
