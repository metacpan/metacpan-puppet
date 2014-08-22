class metacpan::system::perlpackages() {

    # Packages we need to build perl stuff
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
        'libgmp-dev': ensure => present;
    }

}
