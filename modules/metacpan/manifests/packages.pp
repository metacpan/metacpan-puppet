class metacpan::packages {
    # Editors
    package { 'vim': ensure => present }

    # System Tools
    package { bzip2: ensure => present }
    package { curl: ensure => present }
    package { diffutils: ensure => present }
    package { lynx: ensure => present }
    package { mtr: ensure => present }
    package { wget: ensure => present }

    package { htop: ensure => present }
    package { locate: ensure => present }
    package { psmisc: ensure => present } # killall pstree fuser commands
    package { rsync: ensure => present }
    package { screen: ensure => present }

    # ensure locate actually works after install
    # comment this out to save a few seconds on initial install
    exec { "initialize-locate-db":
        command     => "updatedb",
        path        => "/usr/bin/",
        subscribe   => Package["locate"],
        refreshonly => true,
    }

    package { ack-grep: ensure => present }
    package { less: ensure => present }
    package { mosh: ensure => present }
    package { tig: ensure => present }
    package { sudo: ensure => present }
    package { sysstat: ensure => present }
    package { tree: ensure => present }
    package { whois: ensure => present }

    package { ntp: ensure => present }
    # package { exim: ensure => present } # TODO: FIX

    # Stuff for firewall / security
    package { chkrootkit: ensure => present }
    package { iptables: ensure => installed }

    # Euuu - nasty, remove
    package { nano: ensure => absent }

    package{ build-essential: ensure => present }

    # Helped get Elasticsearch running
    # https://ask.puppetlabs.com/question/2147/could-not-find-a-suitable-provider-for-augeas/
    package{ libaugeas-ruby: ensure => present }

    case $operatingsystem {
      Debian: {
      }
      default: {
        Package{ provider => apt }
      }
    }

    # Install a few utilities through node/npm.
    npm::install {
        [
            'js-beautify',
            'cssunminifier',
        ]:
    }
    npm::install { 'less':
      exe => 'lessc',
    }

}
