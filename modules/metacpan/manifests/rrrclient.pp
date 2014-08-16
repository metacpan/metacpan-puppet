class metacpan::rrrclient(
  $enable = hiera('metacpan::rrrclient::enable', 'false')
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
        enable => $enable,
        target => "/var/cpan",
    }->
    service { "rrrclient-metacpan":
      ensure => $enable ? {
          true => running,
          false => stopped,
      },
      enable => $enable,
    }
}
