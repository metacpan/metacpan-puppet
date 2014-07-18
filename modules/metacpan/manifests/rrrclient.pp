class metacpan::rrrclient(
  $perl_version = hiera('perl::version', '5.16.2'),
) {
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
        perl   => $perl_version,
        target => "/var/cpan",
    }->
    service { "rrrclient-metacpan":
        ensure => running,
        enable => true,
    }
}
