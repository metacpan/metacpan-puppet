class metacpan::web::www {
    nginx::vhost { "metacpan.org":
        bare     => true,
        ssl_only => true,
        aliases => ["$hostname.metacpan.org", "lo.metacpan.org"],
    }

    realize File["/etc/nginx/conf.d/metacpan.org.d"]
    file { "/etc/nginx/conf.d/metacpan.org.d/trailing_slash.conf":
        ensure => file,
        content => 'rewrite ^/(.*)/$ /$1 permanent;',
        require => File["/etc/nginx/conf.d/metacpan.org.d"],
        notify  => Service['nginx'],
    }

    nginx::vhost { "www.metacpan.org":
        bare    => true,
        ssl     => true,
        aliases => [".beta.metacpan.org"],
    }
    realize File["/etc/nginx/conf.d/www.metacpan.org.d"]
    file { "/etc/nginx/conf.d/www.metacpan.org.d/redirect.conf":
        ensure => file,
        content => 'rewrite /(.*)$ https://metacpan.org/$1 permanent;',
        require => File["/etc/nginx/conf.d/www.metacpan.org.d"],
        notify  => Service['nginx'],
    }

    $app_root = '/home/metacpan/metacpan.org'

    nginx::proxy { "metacpan.org":
        target   => "http://localhost:5001",
        vhost    => "metacpan.org",
        location => "",
        location_roots => {
            '/static/' => "${app_root}/root",
        },
    }

    startserver { "metacpan-www":
        root    => $app_root,
        perlbin => $perlbin,
        port    => 5001,
        workers => $wwwworkers,
    }->
    service { "metacpan-www":
        ensure => running,
        enable => true,
        require => Service[ 'metacpan-api' ],
    }
}
