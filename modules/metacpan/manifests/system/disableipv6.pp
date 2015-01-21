class metacpan::system::disableipv6 {

  exec {
    "sysctl":
      command => '/sbin/sysctl -p',
      user => 'root',
      group => 'root',
  }

  line {
    "ipv6_1":
      file => "/etc/sysctl.conf",
      ensure => present,
      line => "net.ipv6.conf.all.disable_ipv6 = 1",
      notify => Exec[sysctl];
    "ipv6_2":
      file => "/etc/sysctl.conf",
      ensure => present,
      line => "net.ipv6.conf.default.disable_ipv6 = 1",
      notify => Exec[sysctl];
    "ipv6_3":
      file => "/etc/sysctl.conf",
      ensure => present,
      line => "net.ipv6.conf.lo.disable_ipv6 = 1",
      notify => Exec[sysctl];
    "ipv6_4":
      file => "/etc/sysctl.conf",
      ensure => present,
      line => "net.ipv6.conf.eth0.disable_ipv6 = 1",
      notify => Exec[sysctl];
  }
}
