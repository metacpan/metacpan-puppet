class perl::params(
  $perl_version = hiera('perl::version', '5.16.2'),
) {
  $dir = "/opt/perl-${perl_version}"
  $bin_dir = "${dir}/bin"
}
