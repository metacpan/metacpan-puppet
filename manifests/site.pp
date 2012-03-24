$fileserver = "puppet://localhost/files"
$moduleserver = "puppet://localhost"

import "modules.pp"
import "classes/*.pp"

case $operatingsystem {
  Debian: { 
    Package{ provider => apt }
  }
}

node localhost {
    # Setup all machines the same (for now at least)
    include default_setup
    
    
    
}
