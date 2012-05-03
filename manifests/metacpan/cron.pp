class cron {
	package { cron: ensure => latest }
	
	service { cron:
		ensure => running,
		pattern => "cron",
		require => Package["cron"],
	}

}

class cron::website {
    
    $defaultuser = 'metacpan'
    
    $metacpan_cmd = '$HOME/api.metacpan.org/bin/metacpan'
    
    cron {
        test:
            user    => "$defaultuser",
            environment => "$path_env",
            command => "echo `date` >> /tmp/crontest.log",
            # hour => '*/1',
            minute  => "1",
            ensure  => 'present';
    }
}


