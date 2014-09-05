class metacpan(
  $tmp_dir = hiera('metacpan::tmp_dir','/tmp'),
  $user = hiera('metacpan::user', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),

  ) {

    # Standard metacpan server setup
    include metacpan::system
    include metacpan::user::admins
    include metacpan_elasticsearch
    include metacpan::watcher
    include metacpan::rrrclient

    include starman

    # basic stuff EVERY box needs
    perl::module{'Carton':
      module => 'Carton'
    }

    perl::module{'DaemonControl':
      module => 'Daemon::Control'
    }

    # Sort out our repos and basic websites
    $websites = hiera_hash('metacpan::web::sites', {})
    create_resources('metacpan::web::site', $websites)

    # Run any fire wall stuff here
    $fw_rules = hiera_hash('metacpan::fw_ports', {})
    create_resources('metacpan::system::firewall', $fw_rules)

    metacpan::user { metacpan:
        expire_password   => false,
    }

    file { $tmp_dir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0755',
    }

    file { "/var/tmp/metacpan":
        ensure => link,
        target => $tmp_dir,
        require => File[$tmp_dir],
    }

    include metacpan::web

}
