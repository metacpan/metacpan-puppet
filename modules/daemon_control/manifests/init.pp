# Install init script for Daemon::Control wrapper.
define daemon_control (
    $root,
    $service        = $name,
    $service_enable = true,
    $user           = 'metacpan',
) {
    include daemon_control::deps

    $init     = "/etc/init.d/${service}"
    $env_file = '/home/metacpan/.metacpanrc'
    $script   = "${root}/bin/daemon-control.pl"

    file { $init:
        ensure  => file,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        content => template('daemon_control/init.sh.erb'),
    }

    service { $service:
        ensure  => $service_enable,
        enable  => $service_enable,
        require => File[$init],
    }
}
