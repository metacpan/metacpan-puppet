class metacpan::cron {
  package { cron: ensure => latest }
  
  service { cron:
      ensure => running,
      pattern => "cron",
      require => Package["cron"],
  }

  $defaultuser = 'metacpan'
  $path_env = 'PATH=/usr/local/perlbrew/perls/metalib/bin:/usr/local/bin:/usr/bin:/bin'

}

class metacpan::cron::api inherits metacpan::cron {
    
    $metacpan_cmd = '$HOME/api.metacpan.org/bin/metacpan'
    
    cron {
        test:
            user    => "$defaultuser",
            environment => "$path_env",
            command => "echo `date` >> /tmp/crontest.log",
            # hour => '*/1',
            minute  => "1",
            ensure  => 'present';
    }
}

class metacpan::cron::sysadmin inherits metacpan::cron {
    # To add to later
}

class metacpan::cron::web inherits metacpan::cron {
    # To add to later
}



