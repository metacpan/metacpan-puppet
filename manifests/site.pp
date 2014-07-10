node bm-n1 {
  include metacpan::packages
  include metacpan::exim
    include metacpan::user::admins
}

node bm-n2 {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    $apiworkers = 10
    $wwwworkers = 7

    include metacpan::munin
    include metacpan
    include metacpan::rrrclient
    include metacpan::exim
    include metacpan::user::admins
    include metacpan::cron::api
    include metacpan::cron::clean_up_source
    include metacpan::cron::restart_rrr_client
    include metacpan::cron::daily_rsync
    include metacpan::web::vmbox

    # Only need this on live really atm
    # probably going to be replaced by Mo's JS version
    include metacpan::web::explorer

    elasticsearch { "0.20.2": memory  => 18000 }
}

# dev server

node default {

$foo = hiera('wibble', 33)
notice("The value is... ${foo}")

#    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
#    $apiworkers = 1
#    $wwwworkers = 3

#    include metacpan
#    include metacpan::ssh
#    elasticsearch { "0.20.2":
#      # Give es 70% of the available memory.
      # As of 20140526 the 'facter' installed on the vm is too old to have
      # $memorysize_mb, so use ruby to strip the suffix.
      # Transform GB to MB.
#      memory => inline_template(
#        '<%= (scope.lookupvar("::memorysize").sub(%r/^(.+?)\s*([GM])B$/){ $1.to_f * ($2 == "G" ? 1000 : 1) * 0.70 }.to_i) %>'
#      ),
#    }
}
