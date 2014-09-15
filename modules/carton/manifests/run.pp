define carton::run (
  $root,
  $service,
  $user = hiera('metacpan::user', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),
  $carton_args = hiera('metacpan::carton_args', ''),

) {

  include perl

  $perlbin = $perl::params::bin_dir

  $carton_service_dir = "/home/${user}/carton/${service}"
  file { $carton_service_dir:
      ensure => directory,
      mode   => '0755',
      owner  => $user,
      group => $group,
      require => File["/home/${user}/carton"],
  }

  $carton = "/home/${user}/bin/${service}-carton"
  file { $carton:
      ensure => file,
      mode   => '0755',
      owner  => $user,
      group => $group,
      content => template('carton/carton.erb'),
      require => File["/home/${user}/bin"],
  }

  $carton_exec = "/home/${user}/bin/${service}-carton-exec"
  file { $carton_exec:
      ensure => file,
      mode   => '0755',
      owner  => $user,
      group => $group,
      content => template('carton/carton-exec.erb'),
      require => File["/home/${user}/bin"],
  }

  #
  exec { "run_carton_${service}":
    path    => [$perl::params::bin_dir, '/usr/bin', '/bin' ],
    command => "${carton} install ${carton_args}",
    # needed HOME because `user` does not set it, don't know
    # why carton actually need it, but puppet gets error otherwise
    environment => "HOME=/home/${user}",
    user    => $user,
    group   => $group,
    require => [ File[$carton_service_dir], File[$carton] ],
    timeout => 600, # just incase slow machine
    onlyif => "test -e ${root}/cpanfile", # only if we have a cpanfile
  }

}
