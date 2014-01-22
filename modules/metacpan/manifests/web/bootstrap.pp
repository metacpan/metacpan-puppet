class metacpan::web::bootstrap {
	nginx::vhost { "bootstrap.metacpan.org":
		bare     => true,
	}
	nginx::proxy { "bootstrap.metacpan.org":
		target   => "http://localhost:5032",
		vhost    => "bootstrap.metacpan.org",
		location => "",
	}
	startserver { "metacpan-test":
		root    => "/home/metacpan/boostrap.metacpan.org",
		perlbin => $perlbin,
        port    => 5032,
	}->
	service { "metacpan-bootstrap":
		ensure => running,
		enable => true,
	}
}
