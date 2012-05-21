class metacpan::ssh {

    

}

class metacpan::ssh::server {

    # Sort out ssh file, need dir first
    file{ "/etc/ssh":
            owner => "root",
            group => "root",
            mode => 755,
            ensure => directory,
    }
    # TODO: make sshd restart if this changes, but not really important
    file { "/etc/ssh/sshd_config":
            owner => "root",
            group => "root",
            mode => 644,
            source => "$moduleserver/metacpan/default/etc/ssh/sshd_config",
    }

    
    package { "openssh-client":
      ensure => installed,
    }
    package { "openssh-server":
      ensure => installed,
    }
    user { sshd:
      home => "/var/run/sshd",
      shell => "/usr/sbin/nologin",
      allowdupe => false,
    }
	service { ssh:
		ensure => running,
		pattern => "sshd",
        require => Package["openssh-server"],
	}
}



