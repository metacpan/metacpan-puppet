class metacpan(
  ) {

    # Standard metacpan server setup
    include metacpan::system

    # Sort out our repos
    $websites = hiera_hash('metacpan::websites', {})
    create_resources('metacpan::website', $websites)

    # Run any fire wall stuff here
    $fw_rules = hiera_hash('metacpan::fw_ports', {})
    create_resources('metacpan::system::firewall', $fw_rules)

    metacpan::user { metacpan:
        expire_password   => false,
        source_metacpanrc => true,
    }

    include metacpan::web
    include metacpan::watcher

}
