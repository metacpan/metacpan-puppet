# dev server

node default {
    $perlbin = "/usr/local/perlbrew/perls/perl-5.16.2/bin"

    # FIXME: Set `daemon_control::config::link_dirs: false` in hiera.
    class { 'daemon_control::config': link_dirs => false }

    include metacpan
    include metacpan::ssh
    elasticsearch { "0.20.2":
      # Give es 70% of the available memory.
      # As of 20140526 the 'facter' installed on the vm is too old to have
      # $memorysize_mb, so use ruby to strip the suffix.
      # Transform GB to MB.
      memory => inline_template(
        '<%= (scope.lookupvar("::memorysize").sub(%r/^(.+?)\s*([GM])B$/){ $1.to_f * ($2 == "G" ? 1000 : 1) * 0.70 }.to_i) %>'
      ),
    }
}
