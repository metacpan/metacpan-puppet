class metacpan::web::cpan {
	nginx::vhost { "cpan.metacpan.org":
		html    => "/var/cpan",
		ssl     => true,
		aliases => ["$hostname.cpan.metacpan.org"],
	}
}
