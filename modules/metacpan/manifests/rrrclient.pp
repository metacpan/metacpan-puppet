class metacpan::rrrclient(
  $enable = hiera('metacpan::rrrclient::enable', 'false'),
  $cpan_mirror = hiera('metacpan::cpan_mirror', '/var/cpan'),
  $user = hiera('metacpan::user', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),
) {
    include rrrclient

    file { $cpan_mirror:
        ensure  => directory,
        owner   => $user,
        group   => $group,
        require => User[$user],
    }->
    file { "/home/${user}/CPAN":
        ensure => link,
        target => $cpan_mirror,
        owner  => $user,
        group  => $group,
    }->
    rrrclient::service { metacpan:
        enable => $enable,
        cpan_mirror => $cpan_mirror,
    }

}
