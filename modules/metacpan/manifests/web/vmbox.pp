# vim: set ft=puppet ts=4 sts=4 sw=4 et sta:

class metacpan::web::vmbox (
    $static_only = true,
) {

	$user = 'metacpan'
    $app_root    = '/home/metacpan/vmbox.metacpan.org'

	file {
	    # Copy vmbox.metacpan.org
	    $app_root:
	        ensure  => directory,
	        require => User[$user],
	        recurse => true,
	        owner   => $user,
	        group   => $user,
	        mode    => '0644', # make everything readable
	        source  =>
	            "puppet:///modules/metacpan/default/home/metacpan/vmbox.metacpan.org",
	}

    $vhost_html = $static_only ? {
        true    => "${app_root}/files",
        default => '',
    }

	nginx::vhost { "vmbox.metacpan.org":
		bare      => !$static_only,
		autoindex =>  $static_only,
		html      => $vhost_html,
	}

    $proxy_ensure = !$static_only

	nginx::proxy { "vmbox.metacpan.org":
		ensure   => $proxy_ensure,
		target   => "http://localhost:5005",
		vhost    => "vmbox.metacpan.org",
		location => "",
	}

	startserver { "metacpan-vmbox":
		root    => "/home/metacpan/vmbox.metacpan.org",
		perlbin => $perlbin,
        port    => 5005,
        workers => 2,
	}->
	service { "metacpan-vmbox":
		ensure => $proxy_ensure,
		enable => $proxy_ensure,
	}
}
