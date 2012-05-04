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
            source => "$fileserver/default/etc/aliases",
    }
    # resolv
    file { "/etc/resolv.conf":
            owner => "root",
            group => "root",
            mode => 644,
            source => "$fileserver/default/etc/resolv.conf",
    }
}

