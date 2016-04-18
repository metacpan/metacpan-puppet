class metacpan_postgres::user(
  $user = hiera('metacpan::user', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),
  $password = hiera('metacpan::postgres::password', 'easily-stomp-program'),
  $port = hiera('metacpan::postgres::port', '5432'),
  ) {


	# add in the password file automatically
	include metacpan_postgres::pgpass

	postgresql::server::role { $user:
		password_hash => postgresql_password($user, $password),

		require          => [
			Class['postgresql::globals'],
			Class['postgresql::server::service'],
		],

	}

	postgresql::server::pg_hba_rule { 'give main user TCP database access':
		description        => "Local TCP access for $user",
		type               => 'host',
		database           => 'all',
		user               => $user,
		address            => '0.0.0.0/0',
		auth_method        => 'md5',
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
