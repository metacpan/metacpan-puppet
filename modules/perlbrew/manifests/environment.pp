class perlbrew::environment {
  group {
    "perlbrew":
      ensure => present,
      gid    => 300,
  }

  file { "/etc/profile.d/perlbrew.sh":
      content => "export PERLBREW_ROOT=/usr/local/perlbrew\nsource \$PERLBREW_ROOT/etc/bashrc\n",
      ensure => file,
  }

  user {
    "perlbrew":
      home     => $perlbrew::params::perlbrew_root,
      uid      => 300,
      gid      => "perlbrew",
      shell    => '/bin/bash', # so that "source ${PERLBREW_ROOT}/etc/bashrc" works
      ensure   => present,
  }

  file {
    $perlbrew::params::perlbrew_root:
      ensure  => directory,
      mode    => 0755,
      owner   => perlbrew,
      group   => perlbrew,
      require => [ Group["perlbrew"], User["perlbrew"] ],
  }

  exec {
    "perlbrew_init":
      command => "/bin/sh -c 'umask 022; /usr/bin/env PERLBREW_ROOT=${perlbrew::params::perlbrew_root} ${perlbrew::params::perlbrew_bin} init'",
      creates => "${perlbrew::params::perlbrew_root}/perls",
      user    => "perlbrew",
      group   => "perlbrew",
      require => [ Group["perlbrew"], User["perlbrew"], File[$perlbrew::params::perlbrew_bin] ],
  }
}
