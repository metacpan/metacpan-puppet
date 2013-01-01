class metacpan::web::status {
	include nginx
	file { "/etc/nginx/conf.d/status.conf":
        ensure => file,
        content => template("metacpan/web/status.erb"),
        notify => Service["nginx"],
	}
}
