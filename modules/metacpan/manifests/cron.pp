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

class metacpan::cron::restart_rrr_client {

# BARBIE pointed out an issue where rrr_client misses arbitrary uploads. He and
# ANDK have not been able to pinpoint the problem.  It's rare, but a restart of
# the rrr-client causes it to pick up missed uploads.  It's possible that this
# is the source of some of the issues we have with dists which are a) not
# indexed and b) index cleanly once we trigger a manual indexing

    cron {
      'metacpan_restart_rrr_client':
          user        => 'root',
          command     => '/etc/init.d/rrrclient-metacpan restart > /tmp/restart-rrrclient.txt 2>&1',
          environment => [
            # On bm-n2 start-stop-daemon is in /sbin.
            'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
          ],
          hour        => '3',
          minute      => '30',
          ensure      => 'present';
  }
}

class metacpan::cron::sitemaps {
   cron {
      'metacpan_sitemaps':
          user        => 'metacpan',
          command     => '/home/metacpan/metacpan.org/bin/generate_sitemap.pl',
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
            cmd => 'latest 2&>1 > /dev/null',
            minute => '30';
        "backup_favorite":
            cmd => 'backup --purge --index cpan --type favorite',
            minute => '22';
        "backup_author":
            cmd => 'backup --purge --index cpan --type author',
            minute => '28';
        "backup_user":
            cmd => 'backup --purge --index user',
            minute => '25';
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

