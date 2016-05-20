class metacpan::watcher(
	$enable = hiera('metacpan::watcher::enable', 'false'),
	$user = hiera('metacpan::user','metacpan')
) {
	include perl

	# For the template
	$filename = "metacpan-watcher"
	$description = "Watcher script for PAUSE uploads"
	$app_root = "/home/${user}/metacpan-api"
	$perlbin = $perl::params::bin_dir

	$init     = "/etc/init.d/metacpan-watcher"

	file { $init:
		content => template("metacpan/init_watcher.erb"),
		mode    => 0755,
	}

	service { "metacpan-watcher":
		ensure => $enable ? {
				true => running,
				false => stopped,
		},
		enable => $enable,
		require => [ File[$init] ],
	}

	# if( $enable == true ) {
	#     # Everytime git code updates, restart to get new data
	#     exec { 'restart_watcher':
	#         command => "${init} restart",
	#         require => [ Service['metacpan-watcher'] ],
	#     }
	# }
}
