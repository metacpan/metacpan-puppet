define metacpan::system::ramdisk (
    $size,
    $valid_mins = 0,
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

  case $valid_mins {
    0: {
      $enable_cron = absent
    }
    default: {
      $enable_cron = present
    }

  }

  $cmd = "find ${name} -maxdepth 1 -mindepth 1 -mmin +${valid_mins} -exec rm -rf {}"

  cron {
    "cron_${name}":
        user        => $owner,
        command     => $cmd,
        environment => [
          # On start-stop-daemon is in /sbin.
          'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        ],
        hour        => '*',
        minute      => '*/5',
        ensure      => $enable_cron
  }

}