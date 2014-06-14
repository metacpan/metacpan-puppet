class metacpan {
    $perl = "perl-5.16.2"
    include metacpan::packages
    metacpan::user { metacpan:
        expire_password   => false,
        source_metacpanrc => true,
    }

    include lessc
    include js-beautify
    include cssunminifier

    metacpan::perl {  $perl: }
    include metacpan::ssh
    include metacpan::configs
    include metacpan::web
    include metacpan::watcher
}
