class metacpan::cron {
  package { cron: ensure => latest }
  
  service { cron:
      ensure => running,
      pattern => "cron",
      require => Package["cron"],
  }

  $path_env = 'PATH=/usr/local/perlbrew/perls/metalib/bin:/usr/local/bin:/usr/bin:/bin'

  define meta_cron(cmd, user = 'metacpan', hour = '*', minute, weekday = '*', ensure = 'present') {

      cron {
          "cron_$name":
              user    => "$user",
              environment => "$path_env",
              command => "$cmd",
              hour => "$hour",
              minute  => "$minute",
              weekday => "$weekday",
              ensure  => "$ensure";
      }
  }

  define api_cron(cmd, user = 'metacpan', hour = '*', minute, weekday = '*', ensure = 'absent') {
      $metacpan_cmd = '$HOME/api.metacpan.org/bin/metacpan'

      cron {
          "cron_$name":
              user    => "$user",
              environment => "$path_env",
              command => "$metacpan_cmd $cmd",
              hour => "$hour",
              minute  => "$minute",
              weekday => "$weekday",
              ensure  => "$ensure";
      }
  }
}

class metacpan::cron::api inherits metacpan::cron {
    
    api_cron{
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
            minute => '*';
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
            minute => '*',
            weekday => '3';
        "release":
            cmd => '--skip --age 25 --latest /home/metacpan/CPAN/authors/id/',
            hour => '0',
            minute => '5';
    }
}

class metacpan::cron::sysadmin inherits metacpan::cron {
    # To add to later
}

class metacpan::cron::web inherits metacpan::cron {
    # To add to later
}



