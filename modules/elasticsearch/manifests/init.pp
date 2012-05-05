class elasticsearch {
    
    $user = 'elasticsearch'
    $path = "/usr/local/$user"
    
    # clear out the group first
    group { "$user":
            name      => "$user",
            ensure    => "present",
            provider  => "groupadd",
    }

    user { "$user":
            home       => $path,
            ensure     => "present",
            comment    => "ES User",
            shell      => "/bin/bash",
            gid        => $user,
            provider   => "useradd",
    }
    
    file {
        "/usr/local/$user":
            owner => $user,
            group => $user,
            ensure => directory;
    }
        
    define install_version() {
        
        $tar_name = "elasticsearch-$name.tar.gz"
        $extracted_name = "elasticsearch-$name"
        
        $url = "https://github.com/downloads/elasticsearch/elasticsearch/$tar_name"
        exec {
            "es-download-$name":
                cwd => $path,
                user => $user,
                group => $user,
                command => "/usr/bin/wget $url",
                creates => "$path/$tar_name",
                require => File[ "/usr/local/$user"];
        }
        exec {
            "es-extract-$name":
                cwd => $path,
                user => $user,
                group => $user,
                command => "/bin/tar -xzf $tar_name",
                creates => "$path/$extracted_name",
                require => Exec[ "es-download-$name" ];
        }
        
    }
    
    # 
    # 
    # 
    # 
    # package{["elasticsearch","elasticsearch-plugin-head","jre"]:
    #     ensure => latest,
    # }
    # file{"/etc/sysconfig/elasticsearch":
    #     owner => root,
    #     group => root,
    #     mode => 0444,
    #     source => "puppet:///modules/elasticsearch/elasticsearch.sysconfig",
    #     require => Package["elasticsearch"],
    # }
    # file{"/etc/elasticsearch/elasticsearch.yml":
    #     owner => root,
    #     group => root,
    #     mode => 0444,
    #     source => "puppet:///modules/elasticsearch/elasticsearch.yml",
    #     require => Package["elasticsearch"],
    # }
    # service{"elasticsearch":
    #     hasstatus => true,
    #     hasrestart => true,
    #     ensure => running,
    #     enable => true,
    #     require => File["/etc/sysconfig/elasticsearch"],
    #     subscribe => [Package["elasticsearch"],File["/etc/elasticsearch/elasticsearch.yml"]],
    # }
}

class elasticsearch::install inherits elasticsearch {
    
    
    install_version {
        '0.19.3':
    }
    
    
}


