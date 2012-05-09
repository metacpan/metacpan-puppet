class elasticsearch {
    
    package { "openjdk-6-jre": ensure => 'present' }
    
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
                
        "/etc/security/limits.d/elasticsearch":
            owner  => 'root',
            group  => 'root',
            mode   => 0644,
            source => "$moduleserver/elasticsearch/etc/security/elasticsearch";
    }
        
    define install_version() {
                
        $tar_name = "elasticsearch-$name.tar.gz"
        $extracted_name = "elasticsearch-$name"
        
        $url = "https://github.com/downloads/elasticsearch/elasticsearch/$tar_name"
        exec {
            "es-download-and-extract-$name":
                cwd => $path,
                user => $user,
                group => $user,
                command => "/usr/bin/curl -L $url | /bin/tar -xz",
                creates => "$path/$extracted_name",
                require => File[ "/usr/local/$user"];
        }
        
        file {
            # Install the service folder downloaded from (f24dc18)
            # https://github.com/elasticsearch/elasticsearch-servicewrapper
            "$path/$extracted_name/bin/service":
                    ensure => directory,
                    recurse => true,
                    owner => "$user",
                    group => "$user",
                    mode => '0744', # make everything executible
                    source => "$moduleserver/elasticsearch/service",
                    require => Exec[ "es-download-and-extract-$name" ];
        }
    }
    
    define make_live(version) {
        
        $opt = "/opt/elasticsearch"

        # symlink to this version
        file {
            "$opt":
                owner => $user,
                group => $user,
                ensure => link,
                target => "$path/elasticsearch-$version";
        }
        file {
            "/usr/local/bin/rcelasticsearch":
                owner => 'root',
                group => 'root',
                mode => 0755,
                ensure => link,
                target => "$path/elasticsearch-$version/bin/service/elasticsearch"            
        }
        
        
        # If the symlink changes, or the init.d is missing, run the installer
        exec {
            "update-service-elasticsearch":
                cwd => $opt,
                command => "$opt/bin/service/elasticsearch install",
                creates => "/etc/init.d/elasticsearch",
                subscribe => File[ "/opt/elasticsearch" ];
        }
        
    }


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
        '0.18.5':
            ;
        '0.19.3':
            ;
    }
    make_live {
        'es_live':
            version => '0.18.5',
    }
    
    
}


