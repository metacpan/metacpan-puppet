class metacpan_postgres::firewall(
  $port = hiera('metacpan::postgres::port', '5432'),
) {

	# Open up to the same machines as are in the ES cluster
	# So we don't have to define twice... at lea
  $local_net = hiera_array('metacpan::postgres::access_hosts', [])

  # Add each other server in the cluster, no access to anything
  # outside of this.
  $local_net.each |$source| {

    firewall{ "600 Postgres ${source} - ${name} (${module})":
      ensure  => present,
      dport   => [ $port ],
      proto   => tcp,
      action  => 'accept',
      source  => "${source}/32",
      require          => [
        Class['postgresql::globals'],
        Class['postgresql::server::service'],
      ],
    }

  }
}
