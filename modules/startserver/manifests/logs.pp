class startserver::logs (
    $dir = '/var/log/startserver',
) {
    file { $dir:
        ensure => directory,
        mode   => 0755,
        owner  => 'metacpan',
    }
}
