class metacpan::watcher(
	$perl_version = hiera('perl::version', '5.18.2'),
	$enable = hiera('metacpan::watcher::enable', 'false')
) {
	$filename = "metacpan-watcher"
	$description = "Watcher script for PAUSE uploads"
	$perlbin = "/opt/perl-${perl_version}/bin"
	$app_root = "/home/metacpan/api.metacpan.org"

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
