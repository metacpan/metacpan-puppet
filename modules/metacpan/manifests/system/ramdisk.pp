define metacpan::system::ramdisk (
    $size,
    $owner = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
) {

  file { $name:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    mode   => '0750',
  }
  mount { $name:
    ensure  => 'mounted',
    atboot  => 'true',
    device  => 'none',
    fstype  => 'tmpfs',
    options => "nodev,nosuid,noexec,nodiratime,size=${size}",
    dump    => 0,
    pass    => 0,
    require => File[$name],
  }
}