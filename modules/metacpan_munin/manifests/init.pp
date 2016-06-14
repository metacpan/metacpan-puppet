# fcgi for munin web server - only neded on the master munin node
# rewrite later if need it to be clean, not sure the restart works for example
class metacpan_munin(
  ) {

    package { spawn-fcgi: ensure => present }

    file { "/etc/init.d/munin-fcgi":
    		owner  => 'root',
		    group  => 'root',
    		mode   => '0755',
            source => "puppet:///modules/metacpan_munin/munin-fcgi",
    }

    service { 'munin-fcgi':
    	enable      => true,
    	ensure      => running,
    	require    => [ File['/etc/init.d/munin-fcgi'], Package['spawn-fcgi'] ],
    }


}
