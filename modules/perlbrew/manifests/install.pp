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
    [$perlbrew::params::perlbrew_root, "$perlbrew::params::perlbrew_bin/bin"]:
      ensure => directory,
  }->
  file {
    $perlbrew::params::perlbrew_bin:
      owner   => root,
      group   => root,
      mode    => 0755,
      source  => "puppet:///modules/perlbrew/perlbrew",
  }->
  file {
    $perlbrew::params::patchperl_bin:
      owner   => root,
      group   => root,
      mode    => 0755,
      source  => "puppet:///modules/perlbrew/patchperl",
  }
}
