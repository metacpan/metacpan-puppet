class perl::directories {

  file { '/opt':
    ensure => directory,
    mode   => '0755',
  }

}
