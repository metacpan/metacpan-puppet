class metacpan::system::configs {

    # resolv
    file { "/etc/resolv.conf":
            source => "puppet:///modules/metacpan/default/etc/resolv.conf",
    }

    # log4perl.conf
    file { "/etc/log4perl.conf":
            source => "puppet:///modules/metacpan/default/etc/log4perl.conf",
            owner   => root,
            group   => root,
            mode    => '0644',
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
    #include logrotate::base
    file { "/etc/logrotate.d/dateext":
            content => "dateext",
            require => Package["logrotate"],
    }->
    file { "/etc/logrotate.d/compress":
        content => "compresscmd /bin/bzip2\nuncompresscmd /bin/bunzip2\ncompressext .bz2",
        require => Package["bzip2"],
    }
}
