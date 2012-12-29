define metacpan::cron(
  $cmd,
  $minute,
  $user    = "metacpan",
  $hour    = "*",
  $weekday = "*",
  $ensure  = present,
  $metacpan = "\$HOME/api.metacpan.org/bin/metacpan",
  $path_env = "PATH=/usr/local/perlbrew/perls/$metacpan::perl/bin:/usr/local/bin:/usr/bin:/bin",
) {
  cron {
      "metacpan_$name":
          user        => $user,
          environment => $path_env,
          command     => "$metacpan $cmd",
          hour        => $hour,
          minute      => $minute,
          weekday     => $weekday,
          ensure      => $ensure;
  }
}

class metacpan::cron::api {

    metacpan::cron {
        "author":
            cmd => 'author',
            minute => '0';
        "ratings":
            cmd => 'ratings',
            minute => '20';
        "mirrors":
            cmd => 'mirrors',
            minute => '0';
        "cpantesters":
            cmd => 'cpantesters',
            hour => '*/6',
            minute => '42';
        "latest":
            cmd => 'latest 2&>1 > /dev/null',
            minute => '30';
        "backup_favorite":
            cmd => 'backup --index cpan --type favorite',
            minute => '22';
        "backup_author":
            cmd => 'backup --index cpan --type author',
            minute => '28';
        "backup_user":
            cmd => 'backup --index user',
            minute => '25';
        "backup_purge":
            cmd => 'backup ',
            minute => '10',
            hour   => '4',
            weekday => '3';
        "release":
            cmd => '--skip --age 25 --latest /home/metacpan/CPAN/authors/id/',
            hour => '0',
            minute => '5';
        "tickets":
            cmd => 'tickets',
            minute => '12',
            hour => '3';
    }
}

