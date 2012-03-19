class suse_yum {

    Yumrepo { gpgcheck=>1, enabled=>1 }

    case $operatingsystemrelease {
        11.3: {
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
        }
        12.1: {
            yumrepo {
                "SL-12.1":
                  descr=>"openSuSE Linux 12.1",
                  baseurl=>"http://download.opensuse.org/repositories/server:/http/openSUSE_12.1/";
                "Packman-12.1":
                  descr=>"Packman repository (openSUSE_12.1)",
                  baseurl=>"http://packman.inode.at/suse/openSUSE_12.1/";
                "YaST_Web-12.1":
                  descr=>"Web interface for YaST modules (openSUSE_12.1)",
                  baseurl=>"http://download.opensuse.org/repositories/YaST:/Web/openSUSE_12.1/";
                "repo-oss-12.1":
                  descr=>"openSUSE-12.1-Oss",
                  baseurl=>"http://download.opensuse.org/distribution/12.1/repo/oss/suse/";
            }
        }
    }

}