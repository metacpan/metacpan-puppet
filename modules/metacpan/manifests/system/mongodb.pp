class metacpan::system::mongodb {

    # Was needed for gh.metacpan.org - now using docker
    package { 'mongodb': ensure => absent }
}
