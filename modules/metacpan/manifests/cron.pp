define metacpan::cron(
  $cmd,
  $minute,
  $user    = "metacpan",
  $hour    = "*",
  $weekday = "*",
  $ensure  = present,
  $perl_version = hiera('perl::version','5.18.2'),
  $path_env = "PATH=/opt/perls-${perl_version}/bin:/usr/local/bin:/usr/bin:/bin",
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

class metacpan::cron::clean_up_source {
# Clean up metacpan's source dir so it doesn't max out
  cron {
      "metacpan_clean_up_source":
          user        => 'metacpan',
          command     => "find /var/tmp/metacpan/source/ -mindepth 2 -maxdepth 2 -type d -mtime +120 | head -50000 | xargs rm -rf",
          hour        => '3',
          minute      => '22',
          ensure      => "present";
  }
}


class metacpan::cron::sitemaps {
   cron {
      'metacpan_sitemaps':
          user        => 'metacpan',
          command     => '/home/metacpan/metacpan.org/bin/run bin/generate_sitemap.pl',
          hour        => '2',
          minute      => '30',
          ensure      => 'present';
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
            cmd => 'latest >/dev/null 2>&1',
            minute => '30';
        "backup_favorite":
            cmd => 'backup --index cpan --type favorite',
            hour => 2,
            minute => '22';
        "backup_author":
            cmd => 'backup --index cpan --type author',
            hour => 2,
            minute => '28';
        "backup_user":
            cmd => 'backup --index user',
            hour => 2,
            minute => '25';
        "backup_purge":
            cmd => 'backup --purge',
            minute => '25',
            hour => '1';
        "release":
            cmd => 'release --skip --age 25 --detect_backpan --latest /home/metacpan/CPAN/authors/id/',
            hour => '0',
            minute => '5';
        "tickets":
            cmd => 'tickets',
            minute => '12',
            hour => '3';
    }
}
