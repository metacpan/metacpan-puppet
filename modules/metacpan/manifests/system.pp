class metacpan::system {

  include metacpan::system::directories
  include metacpan::system::configs
  include metacpan::system::exim
  include metacpan::system::packages
  include metacpan::system::perlpackages
  include metacpan::system::ssh

  # TODO, decide if we need munin?
  # if so consider security
  # TODO: make smarter about what to monitor
  # include munin::web
  # include munin-server
}
