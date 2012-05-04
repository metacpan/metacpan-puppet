class metacpan::site {
    
    
    # init_and_rc
    define init_and_rc(filename) {

        file{
            "/etc/init.d/$filename":
                owner => root,
                group => root,
                mode => 0755,
                content => template("metacpan/rc.erb");
        }

        exec {
            "update-rc-$filename":
                command => "/usr/sbin/update-rc.d $filename defaults 18",
                creates => "/etc/rc3.d/S21$filename";
        }

    }


    define nginx() {
        
    }
    
}

class metacpan::site::api inherits metacpan::site {

    $app_root = '/home/metacpan/api.metacpan.org'

    init_and_rc {
        init_api:
            filename => 'metacpan-api',
    }
}

class metacpan::site::web inherits metacpan::site {
    
    $app_root = '/home/metacpan/metacpan.org'
    
    init_and_rc {
        init_web:
            filename => 'metacpan-web',
    }
}