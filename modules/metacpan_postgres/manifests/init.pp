class metacpan_postgres(
  ) {

    # Install postgres
    class { 'postgresql::globals':
 		 manage_package_repo => true,
 		 version             => '9.5',
	}->class { 'postgresql::server': }

	include metacpan_postgres::user
	include metacpan_postgres::firewall

}
