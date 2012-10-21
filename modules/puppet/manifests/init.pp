class puppet::client {

	package { puppet: ensure => latest }

	# Setup perlbal configs
	file {
		"/etc/puppet/puppet.conf":
			owner   => "root",
			group   => "root",
			mode    => 644,
			content => template("puppet/puppet.conf"),
	}

}

