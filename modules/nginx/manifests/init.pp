class nginx {
    package{"nginx":
        ensure => latest,
    }

    service{"nginx":
        hasrestart => true,
        ensure => true,
        enable => true,
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
