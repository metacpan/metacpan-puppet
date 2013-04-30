class metacpan::web::explorer {
	nginx::vhost { "explorer.metacpan.org":
		bare     => true,
	}
	nginx::proxy { "explorer.metacpan.org":
		target   => "http://localhost:5002",
		vhost    => "explorer.metacpan.org",
		location => "",
	}
	startserver { "metacpan-explorer":
		root    => "/home/metacpan/explorer.metacpan.org",
		perlbin => $perlbin,
        port    => 5002,
	}->
	service { "metacpan-explorer":
		ensure => running,
		enable => true,
	}
}
