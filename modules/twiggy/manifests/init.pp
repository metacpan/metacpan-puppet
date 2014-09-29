class twiggy(
  $user = hiera('metacpan::user', 'metacpan')
) {

  include twiggy::config

}
