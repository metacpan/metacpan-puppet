class metacpan::rrrclient(
  $enable = hiera('metacpan::rrrclient::enable', 'false'),
  $cpan_path = hiera('metacpan::rrrclient::cpan_path', '/var/cpan')
) {
    file { $cpan_path:
        ensure  => directory,
        owner   => metacpan,
        group   => metacpan,
        require => User[metacpan],
    }->
    file { "/home/metacpan/CPAN":
        ensure => link,
        target => $cpan_path,
        owner  => metacpan,
        group  => metacpan,
    }->
    rrrclient { metacpan:
        enable => $enable,
        target => $cpan_path,
    }->
    service { "rrrclient-metacpan":
      ensure => $enable ? {
          true => running,
          false => stopped,
      },
      enable => $enable,
    }
}
