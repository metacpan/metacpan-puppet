class metacpan::role::production {

  include metacpan
  include metacpan::web::production
  
  include panopta

}
