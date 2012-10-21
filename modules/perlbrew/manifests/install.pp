class perlbrew::install {
  # package {
  #   "build-essential":
  #     ensure => present,
  # }  
  # package {
  #   "wget":
  #     ensure => present,
  # }

  file {
    $perlbrew::params::perlbrew_bin:
      owner   => root,
      group   => root,
      mode    => 0755,
      source  => "puppet:///modules/perlbrew/perlbrew",
  }->
  exec {
      "perlbrew_patchperl":
        command => "${perlbrew::params::perlbrew_bin} -f -q install-patchperl",
        user    => "perlbrew",
        group   => "perlbrew",
        refreshonly => true,
        # installs fine with return value 13
        returns => [0, 13],
        subscribe => File[$perlbrew::params::perlbrew_bin],
    }
}
