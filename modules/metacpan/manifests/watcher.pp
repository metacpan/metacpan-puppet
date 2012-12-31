class metacpan::watcher {
	$filename = "metacpan-watcher"
	$description = "Watcher script for PAUSE uploads"
	$perlbin = "/usr/local/perlbrew/perls/$metacpan::perl/bin"
	$app_root = "/home/metacpan/api.metacpan.org"

	file { "/etc/init.d/metacpan-watcher":
		content => template("metacpan/init_watcher.erb"),
		mode    => 0755,
	}->
	service { "metacpan-watcher":
		ensure => running,
		enable => true,
	}
}
