# Install init script for starman
define starman::service (
    $root,
    $workers,
    $port,
    $service        = $name,
    $service_enable = true,
    $user = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
) {
    include perl
    include starman::config

    $perlbin   = $perl::params::bin_dir
    $plack_env = $starman::config::plack_env

    $service_name = "starman_${service}"

    $env_file = '/home/metacpan/.metacpanrc'

    if $starman::config::link_dirs {
        $link_root = "${root}/var"
        $log_dir   = "${starman::config::log_dir}/${service}"
        $run_dir   = "${starman::config::run_dir}/${service}"
        $tmp_dir   = "${starman::config::tmp_dir}/${service}"

        file { [$link_root, $log_dir, $run_dir, $tmp_dir ]:
            ensure => directory,
            owner  => $user,
            group  => $user,
            mode   => '0755',
            before => Service[$service_name],
        }

        file { "${link_root}/log":
            ensure => link,
            target => $log_dir,
            require => File[$log_dir],
            before => Service[$service_name],
        }
        file { "${link_root}/run":
            ensure => link,
            target => $run_dir,
            require => File[$run_dir],
            before => Service[$service_name],
        }
        file { "${link_root}/tmp":
            ensure => link,
            target => $tmp_dir,
            require => File[$tmp_dir],
            before => Service[$service_name],
        }

        file { "${link_root}/tmp/scoreboard":
            ensure => directory,
            owner  => $user,
            group  => $user,
            mode   => '0755',
            require => File["${link_root}/tmp"],
            before => Service[$service_name],
        }



    }

    $init     = "/etc/init.d/${service_name}"

    file { $init:
        ensure  => file,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        content => template('starman/init.pl.erb'),
    }

    $carton_name = "carton_${service}"
    starman::carton { $carton_name:
      root => $root,
      service => $service,
    }

    service { $service_name:
        ensure  => $service_enable,
        enable  => $service_enable,
        require => [
          File[$link_root, $log_dir, $run_dir, $init],
          Starman::Carton[$carton_name]
        ],
    }
}
