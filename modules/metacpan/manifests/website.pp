class metacpan::website {
    
    # init_and_rc
    define init_and_rc(filename, init_template, desc, starman_args = '') {

        file{
            "/etc/init.d/$filename":
                owner => root,
                group => root,
                mode => 0755,
                content => template("metacpan/$init_template");
        }

        exec {
            "update-rc-$filename":
                command => "/usr/sbin/update-rc.d $filename defaults 18",
                creates => "/etc/rc3.d/S21$filename";
        }

    }
    

    define nginx() {
        $nginx_log_dir = "/var/log/nginx/$name"

        file{
            # Somewhere for logfiles
            "/var/log/nginx/$name":
                ensure => directory,
                owner => root,
                group => root,
                mode => 0755,
                before => Service["nginx"];

            # The actual config file
            "/etc/nginx/sites-available/$name":
                owner => root,
                group => root,
                mode => 0444,
                content => template("metacpan/nginx_$name.erb"),
                before => Service["nginx"],
                notify => Service["nginx"];

            # Add the symlink to enable
            "/etc/nginx/sites-enabled/$name":
                ensure => link,
                target => "/etc/nginx/sites-available/${name}",
                before => Service["nginx"],
                notify => Service["nginx"];
        }
    }
    
}

class metacpan::website::api inherits metacpan::website {

    $app_root = '/home/metacpan/api.metacpan.org'
    $error_log = '/home/metacpan/api.metacpan.org/var/log/api/starman_error.log'

    init_and_rc {
        init_api:
            filename => 'metacpan-api',
            init_template => 'init_starman.erb',
            desc => 'Metacpan API server',
            starman_args => '-p 5000 --workers 5',
    }

    init_and_rc {
        init_rrr:
            filename => 'metacpan-rrr',
            init_template => 'init_rrr.erb',
            desc => 'Mirror CPAN using rrr',
    }

    init_and_rc {
        init_watcher:
            filename => 'metacpan-watcher',
            init_template => 'init_watcher.erb',
            desc => 'Make sure everything is running ok'
    }

    nginx {
        'api.metacpan.org':
    }

}

class metacpan::website::www inherits metacpan::website {
    
    $app_root = '/home/metacpan/metacpan.org'
    $error_log = '/home/metacpan/metacpan.org/var/log/app.log'
    
    init_and_rc {
        init_web:
            filename => 'metacpan-web',
            init_template => 'init_starman.erb',
            desc => 'Metacpan web front end server',
            starman_args => '-p 5001 --workers 10',
    }
    
    nginx {
        [
        "metacpan.org",
        "sco.metacpan.org", "cpan.metacpan.org", "js.metacpan.org",
        "contest.metacpan.org",
        ]:
    }
    
}