class metacpan::web {
	include metacpan::web::www
	include metacpan::web::api
	include metacpan::web::sco
	include metacpan::web::cpan
	if defined(Class["munin-server"]) {
		include metacpan::web::munin
	}
}
