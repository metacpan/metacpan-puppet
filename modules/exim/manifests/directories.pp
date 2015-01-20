class exim::directories {

  file { '/etc/exim4':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

}
