define nginx::proxy(
        $target,
        $location = "/$name",
        $vhost,
        $vhost_root = "/etc/nginx/conf.d/$vhost",
) {
        file { "${vhost_root}.d":
                ensure => directory,
                require => Nginx::Vhost[$vhost],
        }->
        file { "${vhost_root}.d/$name.conf":
                ensure => file,
                content => template("nginx/proxy.conf.erb"),
                notify => Service["nginx"],
        }
}