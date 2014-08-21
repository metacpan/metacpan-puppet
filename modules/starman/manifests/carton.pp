define starman::carton (
  $root,
  $service,
  $user = hiera('metacpan::user', 'metacpan'),
) {

  include perl

  $carton_service_dir = "/home/${user}/carton/${service}"
  file { $carton_service_dir:
      ensure => directory,
      mode   => '0755',
      owner  => $user,
      require => File["/home/${user}/carton"],
  }

  #
  exec { "run_carton_${service}":
    cwd     => $root,
    path    => [$perl::params::bin_dir, '/usr/bin', '/bin' ],
    environment => "PERL_CARTON_PATH=${carton_service_dir}",
    command => "carton install",
    require => File[$carton_service_dir],
    timeout => 600, # just incase slow machine
  }

}
