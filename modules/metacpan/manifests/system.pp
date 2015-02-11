class metacpan::system {

  include apt

  # For nginx
  class { 'apt::backports':
  }

  include metacpan::system::disableipv6
  include metacpan::system::directories
  include metacpan::system::configs
  include metacpan::system::packages
  include metacpan::system::perlpackages
  include metacpan::system::ssh
  include munin::node
  include exim

}
