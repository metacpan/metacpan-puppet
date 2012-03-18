$fileserver = "puppet://localhost/files"
$moduleserver = "puppet://localhost"

import "modules.pp"
import "classes/*.pp"


case $operatingsystem {
  suse: { 
    include suse_yum
    Package{ provider => yum }
    
  }
}

node localhost {
    # Setup all machines the same (for now at least)
    include default_setup
    
}
