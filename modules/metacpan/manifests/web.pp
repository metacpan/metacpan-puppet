class metacpan::web {
	include metacpan::web::www
	include metacpan::web::api
	include metacpan::web::munin
}