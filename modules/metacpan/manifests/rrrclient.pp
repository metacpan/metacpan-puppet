class metacpan::rrrclient {
    file { "/var/cpan":
        ensure  => directory,
        owner   => metacpan,
        group   => metacpan,
        require => User[metacpan],
    }->
    file { "/home/metacpan/CPAN":
        ensure => link,
        target => "/var/cpan",
        owner  => metacpan,
        group  => metacpan,
    }->
    rrrclient { metacpan:
        perl   => $metacpan::perl,
        target => "/var/cpan",
    }->
    service { "rrrclient-metacpan":
        ensure => running,
        enable => true,
    }
}
