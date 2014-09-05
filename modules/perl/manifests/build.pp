# Installs a version of perl into /opt/perl-${version}
# Dont' call directly, instead use
#
# perl::module{'Carton':
#   module => 'Carton'
# }
#
# which in tern calls
#
# perl::build{$perl_version}
# where $perl_version comes from
# hiera('perl::version', '5.18.2')
#

define perl::build (
    $ensure   = 'present',
) {

  $dir = "/opt/perl-${name}"
  $bin_dir = "${dir}/bin"

  # notice("Perl ${name}")

  case $ensure {
      'installed', 'present': {

          # Install Perl
          $url = 'https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build'
          $command = "curl -s ${url} | perl - ${name} ${dir}"
          exec { "perl_${name}":
            command     => $command,
            creates     => $dir,
            cwd         => '/tmp',
            path        => ['/bin', '/usr/bin'],
            timeout     => 300,
          }

          # Install cpanm
          $cpanm_cmd = "curl -s -L http://cpanmin.us | ${bin_dir}/perl - App::cpanminus"
          exec { "perl_cpanm_${name}":
            command     => $cpanm_cmd,
            creates     => "${bin_dir}/cpanm",
            cwd         => '/tmp',
            path        => ["${bin_dir}", '/bin', '/usr/bin'],
            timeout     => 100,
            require     => Exec["perl_${name}"]
          }

      }
      default: {
          # Something to uninstall it
      }
  }
}
