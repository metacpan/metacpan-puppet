# Setup various system resources for metacpan.
class metacpan(
  $tmp_dir = hiera('metacpan::tmp_dir'),
  $user = hiera('metacpan::user', 'metacpan'),
  $group = hiera('metacpan::group', 'metacpan'),

  ) {

    # Standard metacpan server setup
    include metacpan::system
    include metacpan_elasticsearch
    include metacpan::watcher
    include metacpan::rrrclient
    include metacpan::logstash

    # Setup users
    $users = hiera_hash('metacpan::users', {})
    create_resources('metacpan::user', $users)

    include starman
    include carton

    perl::module{ 'strictures':
        version => '2.000002';
    }

    perl::module{ 'Daemon::Control':
    }

    perl::module{ 'Perl::Critic':
    }

    perl::module{ 'Code::TidyAll':
    }

    perl::module{ 'Perl::Tidy':
    }

    perl::module{ 'Code::TidyAll::Plugin::PerlTidy':
    }

    # Create ramdisks if required
    $ramdisks = hiera_hash('metacpan::system::ramdisks', {})
    create_resources('metacpan::system::ramdisk', $ramdisks)


    # Static sites
    $statics = hiera_hash('metacpan::web::static', {})
    create_resources('metacpan::web::static', $statics)

    # Starman sites
    $websites = hiera_hash('metacpan::web::starman', {})
    create_resources('metacpan::web::starman', $websites)

    # Twiggy sites
    $twiggies = hiera_hash('metacpan::web::twiggy', {})
    create_resources('metacpan::web::twiggy', $twiggies)

    # Swat site
    $swat = hiera_hash('metacpan::system::swat', {})
    create_resources('metacpan::system::swat', $swat)

    # Run any fire wall stuff here
    $fw_rules = hiera_hash('metacpan::fw_ports', {})
    create_resources('metacpan::system::firewall', $fw_rules)

    # Cron jobs for anything
    $crons = hiera_hash('metacpan::crons::general', {})
    create_resources('metacpan::cron::general', $crons)

    # Cron jobs for the API
    $api_crons = hiera_hash('metacpan::crons::api', {})
    create_resources('metacpan::cron::api', $api_crons)

    file { $tmp_dir:
      ensure => directory,
      owner  => $user,
      group  => $group,
      mode   => '0755',
    }

    file { '/var/tmp/metacpan':
        ensure => link,
        target => $tmp_dir,
        require => File[$tmp_dir],
    }

    include metacpan::web

}
