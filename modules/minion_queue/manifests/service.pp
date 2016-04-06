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
    }
}
