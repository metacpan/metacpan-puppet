class starman(
  $user = hiera('metacpan::user', 'metacpan')
) {

  include starman::config

  file { "/home/${user}/carton":
      ensure => directory,
      mode   => '0755',
      owner  => $user,
  }

}
