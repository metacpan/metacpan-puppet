$fileserver = "puppet://localhost/files"
$moduleserver = "puppet://localhost"

import "modules.pp"
import "classes/*.pp"

Yumrepo { gpgcheck=>1, enabled=>1 }

yumrepo {
    "SL-11.3":
      descr=>"openSuSE Linux 11.3",
      baseurl=>"http://download.opensuse.org/repositories/server:/http/openSUSE_11.3/";
    "Packman-11.3":
      descr=>"Packman repository (openSUSE_11.3)",
      baseurl=>"http://packman.inode.at/suse/openSUSE_11.3/";
    "YaST_Web-11.3":
      descr=>"Web interface for YaST modules (openSUSE_11.3)",
      baseurl=>"http://download.opensuse.org/repositories/YaST:/Web/openSUSE_11.3/";
    "repo-oss-11.3":
      descr=>"openSUSE-11.3-Oss",
      baseurl=>"http://download.opensuse.org/distribution/11.3/repo/oss/suse/";
}

case $operatingsystem {
  suse: { Package{ provider => yum } }
}

node localhost {
    # Setup all machines the same (for now at least)
    include default_setup
    
}
