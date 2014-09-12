define carton::run (
  $root,
  $service,
  $user = hiera('metacpan::user', 'metacpan'),
) {

  include perl

  $perlbin = $perl::params::bin_dir

  $carton_service_dir = "/home/${user}/carton/${service}"
  file { $carton_service_dir:
      ensure => directory,
      mode   => '0755',
      owner  => $user,
      require => File["/home/${user}/carton"],
  }

  $carton = "/home/${user}/bin/${service}-carton"
  file { $carton:
      ensure => file,
      mode   => '0755',
      owner  => $user,
      content => template('carton/carton.erb'),
      require => File["/home/${user}/bin"],
  }

  $carton_exec = "/home/${user}/bin/${service}-carton-exec"
  file { $carton_exec:
      ensure => file,
      mode   => '0755',
      owner  => $user,
      content => template('carton/carton-exec.erb'),
      require => File["/home/${user}/bin"],
  }

  #
  exec { "run_carton_${service}":
    cwd     => $root,
    path    => [$perl::params::bin_dir, '/usr/bin', '/bin' ],
    environment => "PERL_CARTON_PATH=${carton_service_dir}",
    command => "carton install",
    user    => $user,
    require => File[$carton_service_dir],
    timeout => 600, # just incase slow machine
    onlyif => "test -e ${root}/cpanfile", # only if we have a cpanfile
  }

}
