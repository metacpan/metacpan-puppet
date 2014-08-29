define nginx::vhost(
        $html = "",
        $ssl_only = false,
        $ssl = $ssl_only,
        $bare = false,
        $autoindex = false,
	      $aliases,
) {
        include nginx

        $log_dir = "/var/log/nginx/${name}"
        $ssl_dir = "/etc/nginx/ssl_certs/${name}"

        file { $log_dir:
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
                file {
                  "${ssl_dir}":
                        ensure => directory,
                        mode => '0700',
                        require => File['/etc/nginx/ssl_certs'];

                  "${ssl_dir}/server.crt":
                        ensure => file,
                        source => [
                        	"puppet:///private/ssl/$name/server.crt",
                                "puppet:///private/ssl/server.crt",
                                "puppet:///files/certs/server.crt",
                        ],
                        notify => Service["nginx"],
                        mode => "0400";

                  "${ssl_dir}/server.key":
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
