define metacpan::web::nginx_extra_confs (
        $ensure   = 'present',
        $site,
        $template,
) {
        $config_dir = "/etc/nginx/conf.d/${site}.d"

        include nginx
        realize File[$config_dir]

        file { "${config_dir}/${template}.conf":
                ensure  => $ensure,
                content => template("metacpan/web/${site}/${template}.erb"),
                notify => Service["nginx"],
                require => File[$config_dir],
        }
}
