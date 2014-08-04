class metacpan_system {

  include metacpan_system::directories
  include metacpan_system::configs
  include metacpan_system::exim
  include metacpan_system::packages
  include metacpan_system::perlpackages
  include metacpan_system::ssh

  # TODO, decide if we need munin?
  # if so consider security
  # TODO: make smarter about what to monitor
  # include munin::web
  # include munin-server
}
