class metacpan_elasticsearch::curator(
) {

  package { 'python-pip':
    ensure => installed,
  }

  package { 'elasticsearch-curator':
    ensure => present,
    provider => pip,
    require => Package['python-pip'],
  }

}
