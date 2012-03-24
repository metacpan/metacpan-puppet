class default_setup {
    include test_setup
    include default_packages
    include default_users
  #  include default_sshd

}

class test_setup {
    # Just to prove puppet it running
    file { "/tmp/puppet_testing.txt":
            owner => "root",
            group => "root",
            mode => 440,
            source => "$fileserver/default/tmp/leo_test.txt",
    }
}

class default_packages {
	# Editors
	package { vim: ensure => present }
	
	# System Tools
	package { mtr: ensure => present }
	package { bzip2: ensure => present }
	package { diffutils: ensure => present }

    package { htop: ensure => present }
    package { psmisc: ensure => present } # killall pstree fuser commands
    package { rsync: ensure => present }
    package { screen: ensure => present }
    package { sudo: ensure => present }
    package { sysstat: ensure => present }
    package { whois: ensure => present }

    # Stuff for firewall / security
    package { iptables: ensure => installed }
    package { chkrootkit: ensure => present }
}

class default_sshd {
    # package { "openssh-client":
    #   ensure => installed,
    # }
    # package { "openssh-server":
    #   ensure => installed,
    # }
    # user { sshd:
    #   home => "/var/run/sshd",
    #   shell => "/usr/sbin/nologin",
    #   allowdupe => false,
    # }
	service { ssh:
		ensure => running,
		pattern => "sshd",
        # require => Package["openssh-server"],
	}
}

class default_users {

    metacpanuser {
        leo_user:
            user => 'leotest', fullname => 'leo test', path => '/home';
        clinton_user:
            user => 'clinton', fullname => 'Clinton Gormley', path => '/home';
        mo_user:
            user => 'mo', fullname => 'Moritz Onken', path => '/home';
        olaf_user:
            user => 'olaf', fullname => 'Olaf Alders', path => '/home';
        rafl_user:
            user => 'rafl', fullname => 'Florian Ragwitz', path => '/home';
    }


}



