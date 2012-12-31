class metacpan {
    $perl = "perl-5.16.2"    
    include metacpan::packages
    metacpan::user { metacpan: }
    metacpan::perl {  $perl: }
    include metacpan::rrrclient
    include metacpan::ssh
    include metacpan::configs
    include metacpan::web
    include metacpan::watcher
}
