class metacpan::role::base {

  include metacpan
  include metacpan::user::admins

  # basic stuff EVERY box needs
  perl::module{'Carton':
    module => 'Carton'
  }

}
