class metacpan::configs {
    # Somewhere for our metacpan config files
    file {
        "/etc/metacpan":
            ensure  => "directory",
            owner   => "root",
            group   => "root";
    }

    # Aliases
    file { "/etc/aliases":
            source => "puppet:///modules/metacpan/default/etc/aliases",
    }
    # resolv
    file { "/etc/resolv.conf":
            source => "puppet:///modules/metacpan/default/etc/resolv.conf",
    }
    
    package { apticron: ensure => present }->
    file { "/etc/apticron/apticron.conf":
            source => "puppet:///modules/metacpan/default/etc/apticron/apticron.conf",
    }

    # make logrotate use dateext for all logs
    # speeds up backups because file names don't change
    include logrotate::base
    file { "/etc/logrotate.d/dateext":
            content => "dateext",
            require => Package["logrotate"],
    }->
    file { "/etc/logrotate.d/compress":
        content => "compresscmd /usr/bin/bzip2\nuncompresscmd /usr/bin/bunzip2",
        require => Package["bzip2"],
    }
}

