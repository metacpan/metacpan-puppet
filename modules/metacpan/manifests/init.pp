class metacpan {

    include metacpan::users
    
}

class metacpan::rc_files {
    

    rc_d{
        "/tmp/a_file":
    }

    define rc_d() {

        # $rc = "/etc/init.d/$name"
        # 
        file{
            "$name":
                owner => root,
                group => root,
                mode => 0755,
                content => template("metacpan/rc.erb");
        }

        # exec {
        #     "update-rc-$name":
        #         command => "/usr/sbin/update-rc.d $name defaults 18",
        #         creates => "/etc/rc2.d/S18$name";
        # }



    }
    
}

class metacpan::cronbase {
  package { cron: ensure => latest }
  
  service { cron:
      ensure => running,
      pattern => "cron",
      require => Package["cron"],
  }

  $defaultuser = 'metacpan'
  $path_env = 'PATH=/usr/local/perlbrew/perls/metalib/bin:/usr/local/bin:/usr/bin:/bin'

}

class metacpan::cron::api inherits metacpan::cronbase {
    
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

class metacpan::cron::sysadmin inherits metacpan::cronbase {
    # To add to later
}

class metacpan::cron::web inherits metacpan::cronbase {
    # To add to later
}



