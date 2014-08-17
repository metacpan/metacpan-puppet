class metacpan(
  ) {

    # Standard metacpan server setup
    include metacpan_system

    # Sort out our repos
    $gitrepos = hiera_hash('metacpan::gitrepos', {})
    create_resources('metacpan::gitrepo', $gitrepos)

    metacpan::user { metacpan:
        expire_password   => false,
        source_metacpanrc => true,
    }

    include metacpan::web
    include metacpan::watcher

}
