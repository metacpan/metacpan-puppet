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
    
    define make_live( version, elasticsearch_memory_mb = '20' ) {
        
        $opt = "/opt/elasticsearch"
        $extracted_name = "elasticsearch-$version"
        $es_path = "$path/$extracted_name"

        file {
            # symlink to this version
            "$opt":
                owner => $user,
                group => $user,
                ensure => link,
                target => "$es_path",
                require => File[ "$path/$extracted_name/bin/service"];

            "/usr/local/bin/rcelasticsearch":
                owner => 'root',
                group => 'root',
                mode => 0755,
                ensure => link,
                require => File[ "$path/$extracted_name/bin/service"],
                target => "$es_path/bin/service/elasticsearch";
                           
            # make sure config files are sorted
            "$es_path/config/elasticsearch.yml":
                owner => $user,
                group => $user,
                mode => 0644,
                content => template('elasticsearch/config/elasticsearch_yml.erb');
            "$es_path/bin/service/elasticsearch.conf":
                owner => $user,
                group => $user,
                mode => 0644,
                content => template('elasticsearch/service/elasticsearch_conf.erb');
                
        }
        
        
        # If the symlink changes, or the init.d is missing, run the installer
        exec {
            "update-service-elasticsearch":
                cwd => $opt,
                command => "$opt/bin/service/elasticsearch install",
                creates => "/etc/init.d/elasticsearch",
                require => File[ "$path/$extracted_name/bin/service"], 
                subscribe => File[ "/opt/elasticsearch" ];
        }
        
        service{"elasticsearch":
            hasstatus => true,
            hasrestart => true,
            ensure => running,
            enable => true,
            subscribe => [ File["$es_path/config/elasticsearch.yml"], File["$es_path/bin/service/elasticsearch.conf"]  ],
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
            elasticsearch_memory_mb => $elasticsearch_memory_mb,
    }
    
}

