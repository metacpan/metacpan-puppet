class metacpan::watcher(
    $enable = hiera('metacpan::watcher::enable', 'false'),
    $user = hiera('metacpan::user','metacpan')
) {
    include perl

    # For the template
    $filename = "metacpan-watcher"
    $description = "Watcher script for PAUSE uploads"
    $app_root = "/home/${user}/metacpan-api"
    $perlbin = $perl::params::bin_dir
    $init     = "/etc/init.d/metacpan-watcher"
    $unitfile = "/lib/systemd/system/metacpan-watcher.service"

    file { $init:
        ensure => absent,
    }
    ~> exec { 'metacpan-watcher-init-systemd-reload':
        command     => 'systemctl daemon-reload',
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    }
    ~> exec { 'metacpan-watcher-init-stop':
        command     => 'systemctl stop metacpan-watcher',
        returns     => [ 0, 5 ],
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    }

    file { $unitfile:
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => template("metacpan/metacpan-watcher.service.erb"),
    }
    ~> exec { 'metacpan-watcher-systemd-reload':
        command     => 'systemctl daemon-reload',
        path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    }

    service { "metacpan-watcher":
        ensure => $enable ? {
            true => running,
            false => stopped,
        },
        enable => $enable,
        require => [ File[$unitfile] ],
    }
}
