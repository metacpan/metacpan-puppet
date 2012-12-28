define nginx::vhost(
        $root = "/var/www/$name",
        $ssl_only = false,
        $ssl = $ssl_only,
        $php = false,
        $bare = false,
) {

        file { [$root, "$root/html", "$root/logs"]:
                ensure => directory,
        }

        if $ssl {
                file { "$root/ssl":
                        ensure => directory,
                        require => File[$root];
                       "$root/ssl/server.crt":
                        ensure => file,
                        source => [
                        	"puppet:///private/ssl/$name/server.crt", "puppet:///private/ssl/server.crt",
                        ],
                        notify => Service["nginx"],
                        mode => "0400";
                       "$root/ssl/server.key":
                        ensure => file,
                        source => [
                        	"puppet:///private/ssl/$name/server.key",
                        	"puppet:///private/ssl/server.key",
                        ],
                        notify => Service["nginx"],
                        mode => "0400",
                }
        }

        file { "/etc/nginx/conf.d/$name.conf":
                ensure => file,
                content => template("nginx/vhost.conf.erb"),
                notify => Service["nginx"],
        }
}