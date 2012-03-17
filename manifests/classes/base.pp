class default_setup {
    include test_setup
    include default_packages


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

#   package { host: ensure => present }
#   package { htop: ensure => present }
#   package { mutt: ensure => present }
#   package { less: ensure => present }
#   package { ncftp: ensure => present }
#   package { ntp: ensure => present }
#   package { ntpdate: ensure => present }
#   package { psmisc: ensure => present } # killall pstree fuser commands
#   package { rsync: ensure => present }
#   package { screen: ensure => present }
#   package { sudo: ensure => present }
#   package { sysstat: ensure => present }
#   package { telnet: ensure => present }
#   package { whois: ensure => present }
# 
#   # Daemons
#   package { memcached: ensure => present } 
# 
#   # Development tools
#   package { gcc:       ensure => present }
#   package { make:      ensure => present }
#   package { libc6:     ensure => present }
#   package { libc6-dev: ensure => present }
#   package { libxml2-utils:   ensure => present }
#   package { pkg-config: ensure => present }
#   package { build-essential: ensure => present }
# # for building ssh
#   
#       
#   # Stuff for firewall / security
#   package { iptables: ensure => installed }
#   package { nmap: ensure => present }
#   package { chkrootkit: ensure => present }
#   package { tcpdump: ensure => present }
#   package { fake: ensure => present }
#   package { dnsutils: ensure => present }
#   package { net-tools: ensure => present } 
# 
# # Stats / Analysis
# package { graphviz: ensure => present } 



}