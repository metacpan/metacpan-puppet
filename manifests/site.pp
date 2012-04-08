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

    # $vhosts = ["metacpan.org", "api.metacpan.org", "cpan.metacpan.org"]
    $vhosts = ['munin.metacpan.org']
    include nginx

}
