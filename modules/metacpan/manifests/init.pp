class metacpan {

    # Standard metacpan server setup
    include metacpan_system

    metacpan::user { metacpan:
        expire_password   => false,
        source_metacpanrc => true,
    }

    # include metacpan::web
    include metacpan::watcher

}
