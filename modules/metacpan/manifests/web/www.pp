class metacpan::web::www {
	nginx::vhost { "metacpan.org":
		bare     => true,
		ssl_only => true,
	}

	nginx::proxy { "metacpan.org":
		target   => "http://localhost:5001",
		vhost    => "metacpan.org",
		location => "",
	}

	startserver { "metacpan-www":
		root    => "/home/metacpan/metacpan.org",
		perlbin => $perlbin,
                port    => 5001,
	}->
	service { "metacpan-www":
		ensure => running,
		enable => true,
		require => Service[ 'metacpan-api' ],
	}
}
