class metacpan::role::base {

  include metacpan

  # basic stuff EVERY box needs
  perl::module{'Carton':
    module => 'Carton'
  }

}
