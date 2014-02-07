

class metacpan::web::vmbox {

	$user = 'metacpan'
	file {
	    # Copy vmbox.metacpan.org
	    "/home/metacpan/vmbox.metacpan.org":
	        ensure  => directory,
	        require => User[$user],
	        recurse => true,
	        owner   => $user,
	        group   => $user,
	        mode    => '0644', # make everything readable
	        source  =>
	            "puppet:///modules/metacpan/default/home/metacpan/vmbox.metacpan.org",

	}

	nginx::vhost { "vmbox.metacpan.org":
		bare     => true,
	}
	nginx::proxy { "vmbox.metacpan.org":
		target   => "http://localhost:5005",
		vhost    => "vmbox.metacpan.org",
		location => "",
	}
	startserver { "metacpan-vmbox":
		root    => "/home/metacpan/vmbox.metacpan.org",
		perlbin => $perlbin,
        port    => 5005,
	}->
	service { "metacpan-vmbox":
		ensure => running,
		enable => true,
	}
}
