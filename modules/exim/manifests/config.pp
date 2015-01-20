class exim::config(
  $readhost    = hiera('exim::readhost',  $::fqdn),
  $smarthost   = hiera('exim::smarthost', 'localhost'),
  $config_type = hiera('exim::config_type', 'satellite'),
  $relayhost   = hiera('exim::relayhost',  ''),
  $login       = hiera('exim::login', ''),
  $password    = hiera('exim::password', ''),
  ) {

  require exim::directories

  file { '/etc/exim4/update-exim4.conf.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('exim/update-exim4.conf.conf.erb'),
  }

  file { '/etc/exim4/passwd.client':
    owner   => 'root',
    group   => 'Debian-exim',
    mode    => '0640',
    content => template('exim/passwd.client.erb'),
  }

  file { '/etc/mailname':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $readhost,
  }

  file { '/etc/aliases':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/exim/aliases',
  }
}
