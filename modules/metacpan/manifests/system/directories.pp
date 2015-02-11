class metacpan::system::directories {

    # We install most stuff in here
    file {
        '/opt':
            owner  => 'root',
            group  => 'root',
            ensure => directory;
    }
    # Make this for if any machine becomes the munin master
    file {
        '/var/www/munin':
            owner  => 'munin',
            group  => 'munin',
            require => User['munin'],
            ensure => directory;
    }


}
