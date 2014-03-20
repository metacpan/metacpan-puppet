class metacpan::web::explorer {
	nginx::vhost { "explorer.metacpan.org":
		root	=> "/home/metacpan/explorer.metacpan.org/build"
	}
}
