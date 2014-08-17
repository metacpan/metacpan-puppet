define nginx::vhost(
        $root = "/var/www/$name",
        $html = "",
        $ssl_only = false,
        $ssl = $ssl_only,
        $php = false,
        $bare = false,
        $autoindex = false,
	      $aliases = "",
) {
        include nginx

        $log_dir = "/var/log/nginx/${name}"

        if $html {
            $html_root = $html
        } else {
            $html_root = "$root/html"
            file { "$root/html":
                ensure => directory,
                require => File[$root],
            }
        }

        file { [$root, $log_dir]:
                ensure => directory,
                require => Package["nginx"],
        }->
        file { "/etc/nginx/conf.d/$name.conf":
                ensure => file,
                content => template("nginx/vhost.conf.erb"),
                notify => Service["nginx"],
        }
        @file { "/etc/nginx/conf.d/$name.d":
                ensure => directory,
                require => Package["nginx"],
        }

        if $ssl {
                file { "$root/ssl":
                        ensure => directory,
                        require => File[$root];
                       "$root/ssl/server.crt":
                        ensure => file,
                        source => [
                        	"puppet:///private/ssl/$name/server.crt",
                                "puppet:///private/ssl/server.crt",
                                "puppet:///files/certs/server.crt",
                        ],
                        notify => Service["nginx"],
                        mode => "0400";
                       "$root/ssl/server.key":
                        ensure => file,
                        source => [
                        	"puppet:///private/ssl/$name/server.key",
                        	"puppet:///private/ssl/server.key",
                                "puppet:///files/certs/server.key",
                        ],
                        notify => Service["nginx"],
                        mode => "0400",
                }
        }
}
