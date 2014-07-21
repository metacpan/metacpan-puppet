class metacpan::role::base {

  # We install most stuff in here
  file {
      '/opt':
          owner  => 'root',
          group  => 'root',
          ensure => directory;
  }

  include metacpan
  include metacpan::user::admins

  # Install ES everywhere, but common.yaml defaults
  # to it being disabled
  # elasticsearch{'install_es':}

  # basic stuff EVERY box needs
  perl::module{'Carton':
    module => 'Carton'
  }

}
