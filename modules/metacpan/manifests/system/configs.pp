class metacpan::system::configs {

    # resolv
    file { "/etc/resolv.conf":
            source => "puppet:///modules/metacpan/default/etc/resolv.conf",
    }

    # So many servers, so much noise! - turn it off
    package { apticron: ensure => absent }->
    file { "/etc/apticron/apticron.conf":
            source => "puppet:///modules/metacpan/default/etc/apticron/apticron.conf",
    }

    # Turn on sysstat
    line { "replace":
        file => "/etc/default/sysstat",
        ensure => replace,
        line => "ENABLED=\"false\"",
        with => "ENABLED=\"true\"",
    }

    # make logrotate use dateext for all logs
    # speeds up backups because file names don't change
    include logrotate::base
    file { "/etc/logrotate.d/dateext":
            content => "dateext",
            require => Package["logrotate"],
    }->
    file { "/etc/logrotate.d/compress":
        content => "compresscmd /bin/bzip2\nuncompresscmd /bin/bunzip2\ncompressext .bz2",
        require => Package["bzip2"],
    }
}
