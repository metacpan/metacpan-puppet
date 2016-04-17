# For servers that only need the pgpass file
# and not the actual user

class metacpan_postgres::pgpass(
  $user = hiera('metacpan::user', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),
  $password = hiera('metacpan::postgres::password', 'easily-stomp-program'),
  $port = hiera('metacpan::postgres::port', '5432'),
  ) {

	# For pgpass template
	 $local_net = hiera_array('metacpan::postgres::access_hosts', ['localhost'])

	# Password file
	file {
		"/home/${user}/.pgpass":
	        owner   => $user,
	        group   => $group,
	        mode    => '0600',
			content => template('metacpan_postgres/pgpass.erb'),
	 }

}
