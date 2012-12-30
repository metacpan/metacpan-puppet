class metacpan::web::www {
	nginx::vhost { "metacpan.org":
		bare     => true,
		ssl_only => true,
		aliases => ["$hostname.metacpan.org", "lo.metacpan.org"],
	}

	nginx::vhost { "www.metacpan.org":
		bare    => true,
		ssl     => true,
		aliases => [".beta.metacpan.org"],
	}
    realize File["/etc/nginx/conf.d/www.metacpan.org.d"]
	file { "/etc/nginx/conf.d/www.metacpan.org.d/redirect.conf":
		ensure => file,
		content => "rewrite /(.*)$ https://metacpan.org/$1 permanent;",
		require => File["/etc/nginx/conf.d/www.metacpan.org.d"],
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
