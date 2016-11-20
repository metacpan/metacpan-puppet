class metacpan::system::rsyslog::certs() {

	#
	file {
      "/etc/rsyslog.d/ca.crt":
            ensure => file,
            source => [
              "puppet:///private/rsyslog/ca.crt",
              "puppet:///dev_fallback/ssl/server.crt",
            ],
            mode => "0444";

      "/etc/rsyslog.d/server.crt":
            ensure => file,
            source => [
              "puppet:///private/rsyslog/rsyslog.crt",
              "puppet:///dev_fallback/ssl/server.crt",
            ],
            mode => "0444";

      "/etc/rsyslog.d/server.key":
            ensure => file,
            source => [
              "puppet:///private/rsyslog/rsyslog.key",
              "puppet:///dev_fallback/ssl/server.key",
            ],
            mode => "0400";
   }

}

