class perlbrew::install {
  # We alreaddy have these
  # package {
  #   "build-essential":
  #     ensure => present,
  # }
  # 
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
      require => [ Package["build-essential"], Package["wget"] ],
  }
}