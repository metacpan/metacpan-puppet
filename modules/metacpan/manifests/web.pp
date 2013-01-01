class metacpan::web {
	include metacpan::web::www
	include metacpan::web::api
	include metacpan::web::sco
	include metacpan::web::cpan
	include metacpan::web::status
	if defined(Class["munin-server"]) {
		include metacpan::web::munin
	}
}
