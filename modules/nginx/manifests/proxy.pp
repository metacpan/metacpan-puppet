define nginx::proxy(
        $ensure   = 'present',
        $target,
        $location = "/$name",
        $vhost,
        $vhost_root = "/etc/nginx/conf.d/$vhost",
        $location_roots = undef, # template var
) {
        include nginx
        realize File["$vhost_root.d"]
        file { "${vhost_root}.d/$name.conf":
                ensure  => $ensure,
                content => template("nginx/proxy.conf.erb"),
                notify => Service["nginx"],
                require => File["$vhost_root.d"],
        }
}
