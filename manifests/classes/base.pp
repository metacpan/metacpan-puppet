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
	package { vim: ensure => latest }
	
	# System Tools
	package { mtr: ensure => latest }
	package { bzip2: ensure => latest }
	package { diffutils: ensure => latest }

#   package { host: ensure => latest }
#   package { htop: ensure => latest }
#   package { mutt: ensure => latest }
#   package { less: ensure => latest }
#   package { ncftp: ensure => latest }
#   package { ntp: ensure => latest }
#   package { ntpdate: ensure => latest }
#   package { psmisc: ensure => latest } # killall pstree fuser commands
#   package { rsync: ensure => latest }
#   package { screen: ensure => latest }
#   package { sudo: ensure => latest }
#   package { sysstat: ensure => latest }
#   package { telnet: ensure => latest }
#   package { whois: ensure => latest }
# 
#   # Daemons
#   package { memcached: ensure => latest } 
# 
#   # Development tools
#   package { gcc:       ensure => latest }
#   package { make:      ensure => latest }
#   package { libc6:     ensure => latest }
#   package { libc6-dev: ensure => latest }
#   package { libxml2-utils:   ensure => latest }
#   package { pkg-config: ensure => latest }
#   package { build-essential: ensure => latest }
# # for building ssh
#   
#       
#   # Stuff for firewall / security
#   package { iptables: ensure => installed }
#   package { nmap: ensure => latest }
#   package { chkrootkit: ensure => latest }
#   package { tcpdump: ensure => latest }
#   package { fake: ensure => latest }
#   package { dnsutils: ensure => latest }
#   package { net-tools: ensure => latest } 
# 
# # Stats / Analysis
# package { graphviz: ensure => latest } 



}