class metacpan::system(
) {

  include apt

  # Set all servers to London timezone
  class { 'timezone':
    region   => 'Europe',
    locality => 'London',
  }

  include metacpan::system::disableipv6
  include metacpan::system::directories
  include metacpan::system::configs
  include metacpan::system::packages
  include metacpan::system::perlpackages
  include metacpan::system::ssh
  include munin::node
  include exim


  include metacpan::system::rsyslog::certs
  #include metacpan::system::rsyslog::client

}
