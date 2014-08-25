define nginx::proxy(
        $ensure   = 'present',
        $target,
        $location = "/$name",
        $conf,
        $vhost_root = "/etc/nginx/conf.d/$conf",
) {
        include nginx
        realize File["$vhost_root.d"]
        file { "${vhost_root}.d/${name}.conf":
                ensure  => $ensure,
                content => template("nginx/proxy.conf.erb"),
                notify => Service["nginx"],
                require => File["$vhost_root.d"],
        }
}
