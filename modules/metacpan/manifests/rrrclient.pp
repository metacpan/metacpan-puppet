class metacpan::rrrclient {
    file { "/home/metacpan/CPAN":
        ensure  => directory,
        owner   => metacpan,
        group   => metacpan,
        require => User[metacpan],
    }->
    rrrclient { metacpan:
        perl => $metacpan::perl,
    }->
    service { "rrrclient-metacpan":
        ensure => running,
        enable => true,
    }
}
