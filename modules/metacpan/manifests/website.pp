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

        service{"$filename":
            # http://docs.puppetlabs.com/references/stable/type.html#service
            hasstatus => true,
            hasrestart => true,
            ensure => running,
            enable => true,
        }

    }


    define starman(
        filename, 
        app_root, 
        desc, 
        starman_port, 
        starman_workers = 5
        ) {

        file{
            "/etc/init.d/$filename":
                owner => root,
                group => root,
                mode => 0755,
                content => template("metacpan/init_starman.erb");
        }

        service{"$filename":
            # http://docs.puppetlabs.com/references/stable/type.html#service
            hasstatus => true,
            hasrestart => true,
            ensure => running,
            enable => true,
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
    
    define rotate_logs(path, rotate = 9999, postrotate = '', copytruncate = false) {
        logrotate::rule { "metacpan_$name":
          path         => $path,
          rotate       => $rotate,
          rotate_every => 'day',
          ifempty      => false,
          missingok    => true,
          compress     => true,
          copytruncate => $copytruncate,
          postrotate   => $postrotate,
        }
    }
    
}

class metacpan::website::api inherits metacpan::website {

    $app_root = '/home/metacpan/api.metacpan.org'
    $log_root = "$app_root/var/log"
    $error_log = '/home/metacpan/api.metacpan.org/var/log/api/starman_error.log'

    starman {
        init_api:
            filename => 'metacpan-api',
            desc => 'Metacpan API server',
            app_root => $app_root,
            starman_port => '5000',
            starman_workers => '5';
    }

    # FIXME: turn this on once it actually starts
    # init_and_rc {
    #     init_watcher:
    #         filename => 'metacpan-watcher',
    #         init_template => 'init_watcher.erb',
    #         desc => 'Make sure everything is running ok',
    #         require => Service[ 'elasticsearch' ]
    # }
    
    # FIXME: this needs to be converted to debian init style
    # init_and_rc {
    #     init_rrr:
    #         filename => 'metacpan-rrr',
    #         init_template => 'init_rrr.erb',
    #         desc => 'Mirror CPAN using rrr',
    # }
    
    nginx {
        'api.metacpan.org':
    }
    
    rotate_logs {
        "api_access_log":
            path => "$log_root/api/access.log",
            postrotate => 'test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`';
        "api_error_log":
            path => "$log_root/api/error.log",
            postrotate => 'test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`';
        "api_starman_error_log":
            path => "$log_root/api/starman_error.log",
            copytruncate => true;
        "api_logs":
            path => "$log_root/*.log",
            copytruncate => true;
            
        # Move this to somewhere later...
        "es_logs":
            path => "/opt/elasticsearch/logs/*.log",
            rotate => 14,
            copytruncate => true;
        
    }


}

class metacpan::website::www inherits metacpan::website {
    
    $app_root = '/home/metacpan/metacpan.org'
    $log_root = "$app_root/var/log"
    $error_log = '/home/metacpan/metacpan.org/var/log/app.log'
    
    rotate_logs {
        "www_logs":
            path => "$log_root/*.log",
            postrotate => 'test ! -f /var/run/nginx.pid || kill -USR1 `cat /var/run/nginx.pid`';
    }
    
    starman {
        init_web:
            filename => 'metacpan-web',
            app_root => $app_root,
            desc => 'Metacpan web front end server',
            starman_port => '5001',
            starman_workers => '10';
    }
    
    nginx {
        [
        "metacpan.org",
        "sco.metacpan.org", "cpan.metacpan.org", "js.metacpan.org",
        "contest.metacpan.org",
        ]:
    }
    
}