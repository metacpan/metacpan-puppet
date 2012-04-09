class perlbrew {
  include perlbrew::params
  include perlbrew::install
  include perlbrew::environment

  define build ($version) {
    exec {
      "perlbrew_build_${name}":
        command => "/bin/sh -c 'umask 022; /usr/bin/env PERLBREW_ROOT=${perlbrew::params::perlbrew_root} ${perlbrew::params::perlbrew_bin} install ${version} --as ${name} -Accflags=-fPIC -Dcccdlflags=-fPIC'",
        user    => "perlbrew",
        group   => "perlbrew",
        timeout => 3600,
        creates => "${perlbrew::params::perlbrew_root}/perls/${name}",
        require => Class["perlbrew::environment"],
    }
  }

  define install_cpanm () {
    exec {
        # puppet seems to change the current user weirdly when using the
        # user/group options. That causes cpanm to use /root/.cpanm for it's
        # temporary storage, which happens to not be writable for the perlbrew
        # user. Use /bin/su to work this around.
      "install_cpanm_${name}":
        command => "/bin/su - -c 'umask 022; wget --no-check-certificate -O- ${perlbrew::params::cpanm_url} | ${perlbrew::params::perlbrew_root}/perls/${name}/bin/perl - App::cpanminus 2>&1 >/tmp/foo.log' perlbrew",
        creates => "${perlbrew::params::perlbrew_root}/perls/${name}/bin/cpanm",
        require => Perlbrew::Build[$name],
    }
  }
  
  # define perlbrew::install_iterate($perl) {
  #     $module_key = "loop_${perl}_${name}"
  #     install_module{ $module_key: module => $name, perl => $perl }
  # }
  # 
  # define install_modules ($perl, $toinstall) {
  #     prefix($perl, $toinstall);
  #     
  #     perlbrew::install_iterate{$toinstall: perl => $perl}   
  # }

  define install_module ($perl, $module) {
    exec {
      "install_module_${perl}_${module}":
        command => "/bin/su - -c 'umask 022; ${perlbrew::params::perlbrew_root}/perls/${perl}/bin/cpanm ${module}' perlbrew >> ${perlbrew::params::perlbrew_root}/cpanm-install.log 2>&1",
        timeout => 1800,
        unless  => "${perlbrew::params::perlbrew_root}/perls/${perl}/bin/perl -m${module} -e1",
        require => Perlbrew::Install_cpanm[$perl],
    }
  }



}
