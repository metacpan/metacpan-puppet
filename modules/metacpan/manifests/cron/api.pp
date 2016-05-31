# Run the API cron jobs
# This is defined in hiera and run via metacpan/init.pp

define metacpan::cron::api(
  $cmd,
  $minute,
  $user    = hiera('metacpan::user','metacpan'),
  $hour    = "*",
  $weekday = "*",
  $ensure  = present,
  $metacpan = '/home/metacpan/bin/metacpan-api-carton-exec bin/metacpan',
  $perl_version = hiera('perl::version','5.22.2'),
) {

  $path_env = "PATH=/opt/perl-${perl_version}/bin:/usr/local/bin:/usr/bin:/bin"

  cron {
      "metacpan_api_$name":
          user        => $user,
          environment => $path_env,
          command     => "$metacpan $cmd",
          hour        => $hour,
          minute      => $minute,
          weekday     => $weekday,
          ensure      => $ensure;
  }
}
