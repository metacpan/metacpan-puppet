$fileserver = "puppet://localhost/files"
$moduleserver = "puppet://localhost"

Yumrepo { gpgcheck=>true, enabled=>true }

yumrepo {
  "SL-11.3":
    descr=>"openSuSE Linux 11.3",
    baseurl=>"http://download.opensuse.org/distribution/11.3/inst-source/suse/";
  "SL-11.3-update":
    descr=>"openSuSE Linux 11.3 updates",
    baseurl=>"http://download.suse.com/update/11.3/"
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
# 
# zypprepo { 'repo-oss':
#      type => 'yast2',
#      descr => 'openSUSE-11.3-OSS',
#      baseurl => 'http://download.opensuse.org/distribution/11.3/repo/oss',
#      enabled => '1',
#      autorefresh => '1',
#      path => '/',
#      keeppackages => '0'
# }