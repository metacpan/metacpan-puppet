class metacpan::web {
	include metacpan::web::www
	include metacpan::web::api
	include metacpan::web::sco
	include metacpan::web::cpan
	include metacpan::web::munin
}
