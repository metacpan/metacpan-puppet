class metacpan::rrrclient(
  $enable = hiera('metacpan::rrrclient::enable', 'false'),
  $cpan_mirror = hiera('metacpan::cpan_mirror', '/var/cpan')
) {
    file { $cpan_mirror:
        ensure  => directory,
        owner   => metacpan,
        group   => metacpan,
        require => User[metacpan],
    }->
    file { "/home/metacpan/CPAN":
        ensure => link,
        target => $cpan_mirror,
        owner  => metacpan,
        group  => metacpan,
    }->
    rrrclient { metacpan:
        enable => $enable,
        target => $cpan_mirror,
    }->
    service { "rrrclient-metacpan":
      ensure => $enable ? {
          true => running,
          false => stopped,
      },
      enable => $enable,
    }
}
