class ossec::firewall (
  $role = hiera("ossec::role", "agent"),
) {
  if( $role == "server" ) {
    $ip_whitelist = hiera_array("ossec::ip_whitelist",[]);
    $ip_whitelist.each |$source| {
			firewall{ "400 OSSEC ${source} - ${name}":
				ensure  => present,
				dport   => [ 1514 ],
				proto   => udp,
				action  => 'accept',
				source  => "${source}/32",
			}
			firewall{ "410 OSSEC Authentication ${source} - ${name}":
				ensure  => present,
				dport   => [ 1515 ],
				proto   => tcp,
				action  => 'accept',
				source  => "${source}/32",
			}
		}
  }
  else {
    $ossec_server = hiera("ossec::server_ip","127.0.0.1");
		firewall{ "400 OSSEC ${source} - ${name}":
			ensure  => present,
			dport   => [ 1514 ],
			proto   => udp,
			action  => 'accept',
			source  => "${ossec_server}/32",
		}
  }
}
