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
        file{"/etc/nginx/conf.d/$name.conf":
            owner => root,
            group => root,
            mode => 0444,
            content => template("nginx/$name.conf"),
            before => Service["nginx"],
            notify => Service["nginx"],
        }
        file{"/var/log/nginx/$name":
            ensure => directory,
            owner => root,
            group => root,
            mode => 0755,
            before => Service["nginx"],
        }
    }
}
