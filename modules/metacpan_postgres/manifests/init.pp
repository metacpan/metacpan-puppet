class metacpan_postgres(
  ) {

    # Install postgres
    class { 'postgresql::globals':
 		 manage_package_repo => true,
 		 version             => '9.6',
	}->class { 'postgresql::server':
	  listen_addresses => '*'
	}

	include metacpan_postgres::user
	include metacpan_postgres::firewall

}
