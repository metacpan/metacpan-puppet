define metacpan_nginx::proxy(
        $ensure   = 'present',
        $target,
        $location = "/$name",
        $site,
        $vhost_root = "/etc/nginx/conf.d/${site}",
) {
        include metacpan_nginx
        realize File["$vhost_root.d"]
        file { "${vhost_root}.d/${name}.conf":
                ensure  => $ensure,
                content => template("metacpan_nginx/proxy.conf.erb"),
                notify => Service["nginx"],
                require => File["$vhost_root.d"],
        }
}
