class metacpan::system::ssh {
  package { ["openssh-server", "openssh-client"]:
    ensure => latest,
  }->
  file {
    "/etc/ssh/sshd_config":
      source => "puppet:///modules/metacpan/default/etc/ssh/sshd_config",
      mode   => '0444',
      owner  => root,
      group  => root,
      notify => Service['ssh'];
  }->
  service { ssh:
    ensure => running,
  }
}
