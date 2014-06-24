define metacpan::perl(
    $version = $name,
) {
    # This assumes Debian.  As of 20140624 we have 6 on bm-n2 and 7 on the vm.
    $gmp_dev_pkg = $lsbmajdistrelease ? {
      6       => 'libgmp3-dev',
      # 7 has this virtual package; assume later versions do too.
      default => 'libgmp-dev',
    }

    # Packages we need to build stuff
    package { 
        # for https
        'libssl-dev': ensure => present;
        # for gzip
        'zlib1g-dev': ensure => present;
        # for Test::XPath 
        'libxml2-dev': ensure => present;
        # for XML::Parser (used by Test::XPath)
        'libexpat1-dev': ensure => present;
        # AnyEvent::Curl::Multi
        'libcurl4-openssl-dev': ensure => present;
        # Net::OpenID::Consumer depends on Crypt::DH::GMP.
        $gmp_dev_pkg: ensure => present;
    }->

    # install the perl
    perlbrew::build { $version: }->

    # install cpanm
    perlbrew::install_cpanm { $version: }
}

