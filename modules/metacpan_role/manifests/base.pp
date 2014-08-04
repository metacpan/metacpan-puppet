class metacpan_role::base(
) {

  include metacpan
  include metacpan::user::admins
  include metacpan_elasticsearch

  # basic stuff EVERY box needs
  perl::module{'Carton':
    module => 'Carton'
  }

  perl::module{'DaemonControl':
    module => 'Daemon::Control'
  }


}
