class metacpan::web::munin {
	nginx::vhost { "munin.metacpan.org":
		html    => "/var/cache/munin/www",
		aliases => ["munin.$hostname.metacpan.org"],
	}
}
