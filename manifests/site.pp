$fileserver = "puppet://localhost/files"
$moduleserver = "puppet://localhost"

Yumrepo { gpgcheck=>true, enabled=>true }

yumrepo {
  "SL-10.2":
    descr=>"openSuSE Linux 10.2",
    baseurl=>"http://download.opensuse.org/distribution/10.2/inst-source/suse/";
  "SL-10.2-update":
    descr=>"openSuSE Linux 10.2 updates",
    baseurl=>"http://download.suse.com/update/10.2/"
}

case $operatingsystem {
  suse: {Package{ provider => yum }}
}

# import "modules.pp"
import "classes/*.pp"

node localhost {
    # Setup all machines the same (for now at least)
    include default_setup
    
}

