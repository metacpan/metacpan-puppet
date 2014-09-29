# Install init script for twiggy
define twiggy::service (
    $root,
    $port,
    $service_enable = true,
    $user = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
) {
    include perl
    include twiggy::config

    $service_name = "twiggy_${name}"

    $perlbin   = $perl::params::bin_dir
    $plack_env = $twiggy::config::plack_env

    if $twiggy::config::link_dirs {
        $link_root = "${root}/var"
        $log_dir   = "${twiggy::config::log_dir}/${name}"
        $run_dir   = "${twiggy::config::run_dir}/${name}"
        $tmp_dir   = "${twiggy::config::tmp_dir}/${name}"

        file { [$link_root, $log_dir, $run_dir, $tmp_dir ]:
            ensure => directory,
            owner  => $user,
            group  => $group,
            mode   => '0755',
            before => Service[$service_name],
        }

        file { "${link_root}/log":
            ensure => link,
            owner  => $user,
            group  => $group,
            target => $log_dir,
            require => File[$log_dir],
            before => Service[$service_name],
        }
        file { "${link_root}/run":
            ensure => link,
            owner  => $user,
            group  => $group,
            target => $run_dir,
            require => File[$run_dir],
            before => Service[$service_name],
        }
        file { "${link_root}/tmp":
            ensure => link,
            owner  => $user,
            group  => $group,
            target => $tmp_dir,
            require => File[$tmp_dir],
            before => Service[$service_name],
        }

        file { "${link_root}/tmp/scoreboard":
            ensure => directory,
            owner  => $user,
            group  => $group,
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
        content => template('twiggy/init.pl.erb'),
        notify => Service[$service_name],
    }

    carton::run { $name:
      root => $root,
    }

    service { $service_name:
        ensure  => $service_enable,
        enable  => $service_enable,
        require => [
          File[$link_root, $log_dir, $run_dir, $init],
          Carton::Run[$name]
        ],
    }
}
