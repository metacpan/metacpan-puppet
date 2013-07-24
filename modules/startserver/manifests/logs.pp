class startserver::logs (
    $dir = '/var/log/startserver',
) {
    file { $dir:
        ensure => directory,
        mode   => 0755,
        owner  => 'metacpan',
    }

    file { "/etc/logrotate.d/startserver":
        ensure => file,
        source => "puppet:///modules/startserver/logrotate.conf",
        # logrotate requires these to be owned by root.
        owner  => 'root',
        group  => 'root',
    }
}
