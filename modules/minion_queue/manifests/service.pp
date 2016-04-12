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

    $service_name = "minion_queue"
    $perlbin   = $perl::params::bin_dir

    $init     = "/etc/init.d/${service_name}"

    file { $init:
        ensure  => file,
        mode    => '0755',
        owner   => $user,
        group   => $group,
        content => template('minion_queue/init.pl.erb'),
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
        command => "${init} restart",
        require => [ Service[$service_name] ],
    }
}
