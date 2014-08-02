class metacpan::role::base(
) {

  # We install most stuff in here
  file {
      '/opt':
          owner  => 'root',
          group  => 'root',
          ensure => directory;
  }

  include metacpan
  include metacpan::user::admins
  include metacpan-elasticsearch

  # basic stuff EVERY box needs
  perl::module{'Carton':
    module => 'Carton'
  }

  perl::module{'DaemonControl':
    module => 'Daemon::Control'
  }


}
