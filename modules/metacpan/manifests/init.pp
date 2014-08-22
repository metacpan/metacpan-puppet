class metacpan(
  ) {

    # Standard metacpan server setup
    include metacpan::system

    # Sort out our repos
    $websites = hiera_hash('metacpan::websites', {})
    create_resources('metacpan::website', $websites)

    metacpan::user { metacpan:
        expire_password   => false,
        source_metacpanrc => true,
    }

    include metacpan::web
    include metacpan::watcher

}
