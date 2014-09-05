class metacpan::system {

  include metacpan::system::directories
  include metacpan::system::configs
  include metacpan::system::exim
  include metacpan::system::packages
  include metacpan::system::perlpackages
  include metacpan::system::ssh

}
