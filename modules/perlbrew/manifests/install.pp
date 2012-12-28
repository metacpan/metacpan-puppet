class perlbrew::install {
  file {
    $perlbrew::params::perlbrew_bin:
      owner   => root,
      group   => root,
      mode    => 0755,
      source  => "puppet:///modules/perlbrew/perlbrew",
      require => [Package["wget"], Package["build-essential"], Package["bzip2"]],
  }->
  file {
    $perlbrew::params::patchperl_bin:
      owner   => root,
      group   => root,
      mode    => 0755,
      source  => "puppet:///modules/perlbrew/patchperl",
  }
}
