# Install init script for minion_queue
# See init.pp for details
class minion_queue::service (
    $workers = hiera('minion_queue::service::workers', 1 ),
    $service_ensure = hiera('minion_queue::service::ensure', 'stopped' ),
    $service_enable = hiera('minion_queue::service::enable', false ),
    $user = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
) {
    include perl

    $service_name   = "minion_queue"
    $description    = "MetaCPAN API Minion Queue"
    $app_root       = "/home/${user}/metacpan-api"
    $perlbin        = $perl::params::bin_dir
    $unitfile       = "/lib/systemd/system/${service_name}.service"

    $init           = "/etc/init.d/${service_name}"

    file { $init:
        ensure  => absent,
    }
    ~> exec { 'minion_queue-init-systemd-reload':
        command     => 'systemctl daemon-reload',
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    }
    ~> exec { 'minion_queue-init-stop':
        command     => "systemctl stop ${service_name}",
        returns     => [ 0, 5 ],
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    }

    file { $unitfile:
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template("minion_queue/service.erb"),
    }
    ~> exec { 'minion_queue-systemd-reload':
        command     => 'systemctl daemon-reload',
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    }

    service { $service_name:
        ensure  => $service_enable,
        enable  => $service_enable,
        # Sit after starman, which will be after git update
        # IF git was used to setup a notify
        require => [ Starman::Service['metacpan-api'] ],
    }

    # Everytime we run puppet, restart the queue
    # ideally we'd subscribe to the git update of metacpan-api
    # but we don't use the git repo on the dev boxes
    exec { 'restart_minion_queue':
        command => "systemctl restart ${service_name}",
        path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
        require => [ Service[$service_name] ],
    }
}
