# Install init script for starman
define starman::service (
    $root,
    $workers,
    $port,
    $service        = $name,
    $service_enable = true,
) {
    include starman::config

    $user      = $starman::config::user
    $plack_env = $starman::config::plack_env

    $init     = "/etc/init.d/starman_${service}"
    $env_file = '/home/metacpan/.metacpanrc'

    if $starman::config::link_dirs {
        $link_root = "${root}/var"
        $log_dir   = "${starman::config::log_dir}/${service}"
        $run_dir   = "${starman::config::run_dir}/${service}"

        file { [$link_root, $log_dir, $run_dir]:
            ensure => directory,
            owner  => $user,
            mode   => '0755',
            before => Service[$service],
        }

        file { "${link_root}/log":
            ensure => link,
            target => $log_dir,
            before => Service[$service],
        }
        file { "${link_root}/run":
            ensure => link,
            target => $run_dir,
            before => Service[$service],
        }
    }

    file { $init:
        ensure  => file,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        content => template('starman/init.pl.erb'),
    }

    service { $service:
        ensure  => $service_enable,
        enable  => $service_enable,
        require => File[$init],
    }
}
