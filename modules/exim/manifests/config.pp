class exim::config(
  $readhost    = hiera('exim::readhost',  $::fqdn),
  $smarthost   = hiera('exim::smarthost', 'localhost'),
  $config_type = hiera('exim::config_type', 'internet'),
  $relayhost   = hiera('exim::relayhost',  ''),
  ) {

  require exim::directories

  if( $config_type == 'satellite' ) {

    # Should only be on production
    file { '/etc/exim4/passwd.client':
      owner   => 'root',
      group   => 'Debian-exim',
      mode    => '0640',
      source =>
          "puppet:///private/etc/exim4/passwd.client",
    }

  }

  file { '/etc/exim4/update-exim4.conf.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('exim/update-exim4.conf.conf.erb'),
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
