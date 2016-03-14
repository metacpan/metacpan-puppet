class metacpan::system::postgress(
  $user = hiera('metacpan::user', 'metacpan'),
  ) {


	# Delete this old version
	file {
		"/usr/lib/postgresql/9.1":
			ensure => 'absent',
			recurse => true,
		    purge => true,
		    force => true,
	}

    # Install postgress
    class { 'postgresql::globals':
 		 manage_package_repo => true,
 		 version             => '9.5',
	}->class { 'postgresql::server': }

	postgresql::server::role { $user:

	}

	postgresql::server::pg_hba_rule { 'give main user TCP database access':
		description        => "Local TCP access for $user",
		type               => 'host',
		database           => 'all',
		user               => $user,
		address            => '127.0.0.1/32',
		auth_method        => 'ident',
  	}

	postgresql::server::pg_hba_rule { 'give main user socket database access':
		description        => "Local socket access for $user",
		type               => 'local',
		database           => 'all',
		user               => $user,
		auth_method        => 'peer',
  	}

  	# Add a database for the minion queue
	postgresql::server::database { 'minion_queue':
		owner 			   => $user,
		require => "Postgresql::Server::Role[$user]",
	}


}
