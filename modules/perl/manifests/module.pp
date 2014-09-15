# perl::module{ 'File::Rsync::Mirror::Recent':
#}

# Specific projects should use carton/cpanfile.
# This is for bootstraping and other things that
# can not use Carton easily.

define perl::module (
    $ensure   = 'present',
    $module   = $name,
    $perl_version = hiera('perl::version', '5.18.2'),
) {

    require stdlib

    ensure_resource('perl::build', $perl_version )

    $bin_dir = "/opt/perl-${perl_version}/bin"
    $perldoc = "${bin_dir}/perldoc"
    $cpanm = "${bin_dir}/cpanm"

    # cpanm will work out if already installed/latest or not
    # so we won't bother
    exec { "perl_module_${name}":
      command     => "${cpanm} ${module}",
      cwd         => '/tmp',
      path        => ["${bin_dir}", '/bin', '/usr/bin', '/usr/local/bin'],
      timeout     => 300,
      require     => [ Exec["perl_cpanm_${perl_version}"], File["/opt"] ],
    }
}
