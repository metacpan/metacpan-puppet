class metacpan::system::directories {

    # We install most stuff in here
    file {
        '/opt':
            owner  => 'root',
            group  => 'root',
            ensure => directory;
    }

}
