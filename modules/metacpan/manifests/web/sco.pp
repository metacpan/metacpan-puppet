class metacpan::web::sco {
	nginx::vhost { "search.cpan.org":
		bare     => true,
		aliases => ["sco.metacpan.org", "cpansearch.perl.org", ".mcpan.org"],
	}

        realize(File["/etc/nginx/conf.d/search.cpan.org.d"])
	file { "/etc/nginx/conf.d/search.cpan.org.d/rewrite.conf":
		ensure => file,
		source => ["puppet:///modules/metacpan/www/sco.conf"],
	}
}
