class metacpan::web:munin {
	nginx::vhost { "munin.metacpan.org":
		root => "/srv/www/htdocs/munin/",
	}
}