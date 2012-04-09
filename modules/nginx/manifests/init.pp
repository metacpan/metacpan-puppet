class nginx {
    package{"nginx":
        ensure => latest,
    }

    service{"nginx":
        hasrestart => true,
        ensure => true,
        enable => true,
    }


    group { "nginx":
            name      => "nginx",
            ensure    => "present",
            provider  => "groupadd",
    }

    user { "nginx":
            home => "/var/lib/nginx",
            ensure     => "present",
#            comment    => "$fullname",
            shell      => "/bin/false",
            gid        => "nginx",
            provider   => "useradd",
    }


    # Copy across these files
    nginx_files{[
        "nginx.conf",
        "fastcgi.conf", "mime.types",
        "scgi_params", "uwsgi_params"
    ]: }
    
    define nginx_files() {
        file{
            "/etc/nginx/$name":
                owner => root,
                group => root,
                mode => 0644,
                source => "$moduleserver/nginx/$name";
        }
    }

    vhost{$vhosts: }

    define vhost(){
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
                content => template("nginx/$name.erb"),
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
