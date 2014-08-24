# Ensure resources from previously setup startserver instance are removed.
define startserver::remove (
    $filename = $name,
) {
    $init = "/etc/init.d/${filename}"

    # Do exec instead of service so that we can test if it's still there.
    exec { "stop and remove service '${filename}'":
        path    => '/usr/sbin:/usr/bin:/sbin:/bin',
        command => "${init} stop && update-rc.d ${filename} remove",
        onlyif  => "test -x ${init} && ${init} status",
    }
    ->
    file { $init:
        ensure => absent,
    }
}

