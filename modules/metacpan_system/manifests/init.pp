class metacpan_system {
  include metacpan_system::configs
  include metacpan_system::exim
  include metacpan_system::packages
  include metacpan_system::perl
  include metacpan_system::ssh

  # TODO: make smarter about what to monitor
  include munin::web
#    include munin-server
}
