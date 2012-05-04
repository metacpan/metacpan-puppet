class metacpan::site {
    
    
    # init_and_rc
    define init_and_rc(filename) {

        file{
            "/etc/init.d/$filename":
                owner => root,
                group => root,
                mode => 0755,
                content => template("metacpan/init_starman.erb");
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
    $error_log = '/home/metacpan/api.metacpan.org/var/log/api/starman_error.log'

    init_and_rc {
        init_api:
            filename => 'metacpan-api',
            rc_template => 'starman',
    }
}

class metacpan::site::web inherits metacpan::site {
    
    $app_root = '/home/metacpan/metacpan.org'
    $error_log = '/home/metacpan/metacpan.org/var/log/app.log'
    
    init_and_rc {
        init_web:
            filename => 'metacpan-web',
    }
}