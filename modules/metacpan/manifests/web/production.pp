# Just for production servers
class metacpan::web::production(
    $user = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
) {

  file { "/home/${user}/metacpan-web/metacpan_web_local.conf":
      ensure => file,
      owner => $user,
      group => $group,
      source => "puppet:///private/metacpan-web/metacpan_web_local.conf",
      notify => Starman::Service['metacpan-web'],
  }

}
