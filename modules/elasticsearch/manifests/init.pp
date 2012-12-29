define elasticsearch(
    $version = $name,
    $memory  = 64,
    $user    = "elasticsearch",
    $path    = "/opt",
) {
    $opt       = "$path/elasticsearch"
    $extracted = "elasticsearch-$version"
    $es_path   = "$path/$extracted"
    $tar_name  = "elasticsearch-$version.tar.gz"
    $url       = "http://download.elasticsearch.org/elasticsearch/elasticsearch/$tar_name"

    group { $user: ensure => present }->
    user { $user:
            comment => "ElasticSearch User",
            shell   => "/bin/bash",
            gid     => $user,
    }->
    

    file {
        "/var/elasticsearch":
            owner  => $user,
            group  => $user,
            ensure => directory,
    }->

    file {
        $path:
            owner  => $user,
            group  => $user,
            ensure => directory;
                
        "/etc/security/limits.d/elasticsearch":
            source => "puppet:///modules/elasticsearch/etc/security/elasticsearch";
    }
        
    exec {
        "es-download-and-extract-$version":
            cwd     => $path,
            user    => $user,
            group   => $user,
            command => "/usr/bin/curl -L $url | /bin/tar -xz",
            creates => "$path/$extracted",
            require => File[ "$path" ];
    }->
    
    file {
        # Install the service folder downloaded from (f24dc18)
        # https://github.com/elasticsearch/elasticsearch-servicewrapper
        "$path/$extracted/bin/service":
                ensure  => directory,
                recurse => true,
                owner   => $user,
                group   => $user,
                mode    => 0755, # make everything executable
                source  => "puppet:///modules/elasticsearch/service",
    }

    file {
        # symlink to this version
        "$opt":
            owner   => $user,
            group   => $user,
            ensure  => link,
            target  => "$es_path",
            require => File[ "$path/$extracted/bin/service"];

        "/usr/local/bin/rcelasticsearch":
            mode    => 0755,
            ensure  => link,
            require => File[ "$path/$extracted/bin/service"],
            target  => "$opt/bin/service/elasticsearch";
                       
        # make sure config files are sorted
        "$es_path/config/elasticsearch.yml":
            owner   => $user,
            group   => $user,
            content => template('elasticsearch/config/elasticsearch_yml.erb');
        "$es_path/bin/service/elasticsearch.conf":
            owner   => $user,
            group   => $user,
            content => template('elasticsearch/service/elasticsearch_conf.erb');
            
    }->
    
    # If the symlink changes, or the init.d is missing, run the installer
    exec {
        "update-service-elasticsearch":
            cwd       => $opt,
            command   => "$opt/bin/service/elasticsearch install",
            creates   => "/etc/init.d/elasticsearch",
            require   => File[ "$path/$extracted/bin/service"], 
            subscribe => File[ "/opt/elasticsearch" ];
    }->
    
    package { "openjdk-6-jre": ensure => 'present' }->
    service{ "elasticsearch":
        hasstatus  => true,
        hasrestart => true,
        ensure     => running,
        enable     => true,
        require    => File["/etc/security/limits.d/elasticsearch"],
        subscribe  => [
            File["$es_path/config/elasticsearch.yml"],
            File["$es_path/bin/service/elasticsearch.conf"]
        ],
    }
}
