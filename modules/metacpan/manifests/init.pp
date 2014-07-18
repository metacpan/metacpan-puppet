class metacpan {

    include metacpan::packages
    metacpan::user { metacpan:
        expire_password   => false,
        source_metacpanrc => true,
    }

    include metacpan::perl
    include metacpan::ssh
    include metacpan::configs
    # include metacpan::web
    include metacpan::watcher

}
