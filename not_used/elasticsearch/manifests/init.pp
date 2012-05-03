class elasticsearch {
    package{["elasticsearch","elasticsearch-plugin-head","jre"]:
        ensure => latest,
    }
    file{"/etc/sysconfig/elasticsearch":
        owner => root,
        group => root,
        mode => 0444,
        source => "puppet:///modules/elasticsearch/elasticsearch.sysconfig",
        require => Package["elasticsearch"],
    }
    file{"/etc/elasticsearch/elasticsearch.yml":
        owner => root,
        group => root,
        mode => 0444,
        source => "puppet:///modules/elasticsearch/elasticsearch.yml",
        require => Package["elasticsearch"],
    }
    service{"elasticsearch":
        hasstatus => true,
        hasrestart => true,
        ensure => running,
        enable => true,
        require => File["/etc/sysconfig/elasticsearch"],
        subscribe => [Package["elasticsearch"],File["/etc/elasticsearch/elasticsearch.yml"]],
    }
}
