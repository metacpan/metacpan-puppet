class metacpan(
  ) {

    # Standard metacpan server setup
    include metacpan::system

    # Sort out our repos and basic websites
    $websites = hiera_hash('metacpan::web::sites', {})
    create_resources('metacpan::web::site', $websites)

    # Run any fire wall stuff here
    $fw_rules = hiera_hash('metacpan::fw_ports', {})
    create_resources('metacpan::system::firewall', $fw_rules)

    metacpan::user { metacpan:
        expire_password   => false,
    }

    include metacpan::web
    include metacpan::watcher

}
