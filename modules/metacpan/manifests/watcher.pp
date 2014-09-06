class metacpan::watcher(
	$enable = hiera('metacpan::watcher::enable', 'false'),
	$user = hiera('metacpan::user','metacpan')
) {
	include perl

	$filename = "metacpan-watcher"
	$description = "Watcher script for PAUSE uploads"
	$app_root = "/home/${user}/metacpan-api"
	$perlbin = $perl::params::bin_dir

	file { "/etc/init.d/metacpan-watcher":
		content => template("metacpan/init_watcher.erb"),
		mode    => 0755,
	}->
	service { "metacpan-watcher":
		ensure => $enable ? {
				true => running,
				false => stopped,
		},
		enable => $enable,
	}
}
