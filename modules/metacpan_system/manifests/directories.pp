class metacpan_system::directories {

    # We install most stuff in here
    file {
        '/opt':
            owner  => 'root',
            group  => 'root',
            ensure => directory;
    }

    # Somewhere for our metacpan config files
    # TODO: think this is only munin, do we still
    # need it?
    file {
        "/etc/metacpan":
            owner   => "root",
            group   => "root",
            ensure  => "directory",
    }
}
