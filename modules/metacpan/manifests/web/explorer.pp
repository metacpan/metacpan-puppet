class metacpan::web::explorer {
	nginx::vhost { "explorer.metacpan.org":
		html	=> "/home/metacpan/explorer.metacpan.org/build"
	}
}
