class metacpan::web::www (
    # FIXME: This $wwwworkers var is set in the node manifest.
    # FIXME: Make this a sensible default and override with hiera.
    $workers = $wwwworkers,
) {
    # include metacpan::web::api

    realize File["/etc/nginx/conf.d/metacpan.org.d"]
    file { "/etc/nginx/conf.d/metacpan.org.d/trailing_slash.conf":
        ensure => file,
        content => 'rewrite ^/(.*)/$ /$1 permanent;',
        require => File["/etc/nginx/conf.d/metacpan.org.d"],
        notify  => Service['nginx'],
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
    }

    $service = 'metacpan-org'

    # $perlbin isn't needed because the script sources the metacpanrc file.
    daemon_control { $service:
        root    => $app_root,
        port    => 5001,
        workers => $workers,
        require => [
            # Web needs API.
            Service[ $metacpan::web::api::service ],
        ],
    }

    file { '/home/metacpan/metacpan.org/root/static/sitemaps':
        ensure => directory,
        owner => 'metacpan',
        group => 'metacpan',
    }
}
