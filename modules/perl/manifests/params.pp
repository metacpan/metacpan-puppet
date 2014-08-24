#
# include perl
# $perl::params::dir
# $perl::params::bin_dir
#
class perl::params(
  $perl_version = hiera('perl::version', '5.18.2'),
) {
  $dir = "/opt/perl-${perl_version}"
  $bin_dir = "${dir}/bin"
}
