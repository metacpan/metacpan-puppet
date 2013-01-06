class nginx {
        package { "nginx":
                ensure => installed,
        }->
        file { "/etc/nginx/conf.d/basics.conf":
                source => "puppet:///modules/nginx/basics.conf",
                ensure => file,
        }->

        file { "/etc/logrotate.d/nginx":
                source => "puppet:///modules/nginx/logrotate.conf",
                ensure => file,
        }->

        file { "/etc/nginx/conf.d/types.conf":
                source => "puppet:///modules/nginx/types.conf",
                ensure => file,
        }->

	file { "/var/www":
		ensure => directory,
	}->

        service { "nginx":
                ensure => running,
        }
}
