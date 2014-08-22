class metacpan::web::cpan(
) {
	# nginx::vhost { "cpan.metacpan.org":
	# 	html      => $cpan_mirror,
	# 	ssl       => true,
	# 	autoindex => true,
	# 	aliases   => ["cpan.$hostname.metacpan.org", "cpan.lo.metacpan.org"],
	# }

  realize File["/etc/nginx/conf.d/cpan.metacpan.org.d"]
	file { "/etc/nginx/conf.d/cpan.metacpan.org.d/cdn-fastly.conf":
		ensure => file,
		source => ["puppet:///modules/metacpan/www/cpan.conf"],
		require => File["/etc/nginx/conf.d/cpan.metacpan.org.d"],
	}

}
