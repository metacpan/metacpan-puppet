# == Class: exim
#
# Install and config exim
#
# exim::smarthost: 'somesmart.host.com'
# exim::readhost: '<hostname>.metacpan.org', # who email comes from

class exim() {

  package { 'exim4': ensure => present }

  include exim::directories

  include exim::config

  # make sure it's running and reloads when the config files change
  service { 'exim4':
    ensure    => running,
    hasrestart => true,
    restart    => 'service exim4 reload',
    hasstatus  => true,
    require   => Package['exim4'],
    subscribe => [ Class['exim::config'] ],
  }

}
