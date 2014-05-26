# dev server

node default {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"
    $apiworkers = 1
    $wwwworkers = 3

    include metacpan
    include metacpan::ssh
    elasticsearch { "0.20.2":
      # Give es 70% of the available memory.
      # As of 20140526 the 'facter' installed on the vm is too old to have
      # $memorysize_mb, so use ruby to strip the suffix.
      memory => inline_template('<%= (scope.lookupvar("::memorysize").sub(%r/\s*MB$/, "").to_f * 0.70).to_i %>'),
    }
}
