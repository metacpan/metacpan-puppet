class metacpan::packages {
	# Editors
	package { vim: ensure => present }

	# System Tools
	package { curl: ensure => present }
	package { wget: ensure => present }
	package { lynx: ensure => present }
	package { mtr: ensure => present }
	package { bzip2: ensure => present }
	package { diffutils: ensure => present }

    package { htop: ensure => present }
    package { psmisc: ensure => present } # killall pstree fuser commands
    package { rsync: ensure => present }
    package { screen: ensure => present }
    package { locate: ensure => present }

    # ensure locate actually works after install
    # comment this out to save a few seconds on initial install
    exec { "initialize-locate-db":
        command     => "updatedb",
        path        => "/usr/bin/",
        subscribe   => Package["locate"],
        refreshonly => true,
    }

    package { sudo: ensure => present }
    package { less: ensure => present }
    package { sysstat: ensure => present }
    package { whois: ensure => present }
    package { ack-grep: ensure => present }
    package { tree: ensure => present }
    package { mosh: ensure => present }

    package { ntp: ensure => present }
    package { apticron: ensure => present }
    # package { exim: ensure => present } # TODO: FIX

    # Stuff for firewall / security
    package { iptables: ensure => installed }
    package { chkrootkit: ensure => present }

    # Euuu - nasty, remove
    package { nano: ensure => absent }
    package{ build-essential: ensure => present }

    case $operatingsystem {
      Debian: {
      }
      default: {
        Package{ provider => apt }
      }
    }
}



