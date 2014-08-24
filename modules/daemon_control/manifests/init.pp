# Install init script for Daemon::Control wrapper.
define daemon_control (
    $root,
    $workers,
    $port,
    $service        = $name,
    $service_enable = true,
) {
    include daemon_control::config
    include daemon_control::deps

    $user      = $daemon_control::config::user
    $plack_env = $daemon_control::config::plack_env

    $init     = "/etc/init.d/${service}"
    $env_file = '/home/metacpan/.metacpanrc'

    if $daemon_control::config::link_dirs {
        $link_root = "${root}/var"
        $log_dir   = "${daemon_control::config::log_dir}/${service}"
        $run_dir   = "${daemon_control::config::run_dir}/${service}"

        file { [$log_dir, $run_dir]:
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
        content => template('daemon_control/init.pl.erb'),
    }

    service { $service:
        ensure  => $service_enable,
        enable  => $service_enable,
        require => File[$init],
    }
}
