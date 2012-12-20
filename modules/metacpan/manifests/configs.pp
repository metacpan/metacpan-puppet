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
            owner => "root",
            group => "root",
            mode => 644,
            source => "$moduleserver/metacpan/default/etc/aliases",
    }
    # resolv
    file { "/etc/resolv.conf":
            owner => "root",
            group => "root",
            mode => 644,
            source => "$moduleserver/metacpan/default/etc/resolv.conf",
    }
    
    # apticron
    file {
        "/etc/apticron":
            ensure  => "directory",
            owner   => "root",
            group   => "root";
    }
    file { "/etc/apticron/apticron.conf":
            owner => "root",
            group => "root",
            mode => 644,
            source => "$moduleserver/metacpan/default/etc/apticron/apticron.conf",
    }
    
    
    # SSL
    file {
        "/home/metacpan/certs":
            ensure => "directory",
            owner  => "metacpan",
            group  => "metacpan",
    }
    file { "/home/metacpan/certs/metacpan.pem":
            owner  => "metacpan",
            group  => "metacpan",
            mode   => 644,
            source => "$moduleserver/metacpan/default/home/metacpan/certs/self-signed/metacpan.pem",
    }
    file { "/home/metacpan/certs/metacpan.key":
            owner  => "metacpan",
            group  => "metacpan",
            mode   => 644,
            source => "$moduleserver/metacpan/default/home/metacpan/certs/self-signed/metacpan.key",
    }

    # make logrotate use dateext for all logs
    # speeds up backups because file names don't change
    file { "/etc/logrotate.d/dateext":
            content => "dateext",
            ensure => file,
            require => Package["logrotate"],
    }
}

