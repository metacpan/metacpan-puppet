class metacpan::system::packages {

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
    package { iotop: ensure => present }
    package { psmisc: ensure => present } # killall pstree fuser commands
    package { rsync: ensure => present }
    package { screen: ensure => present }

    # for monitoring
    # https://debian-administration.org/article/327/Monitoring_your_hardware's_temperature
    package { lm-sensors: ensure => present } # sensors cmd for cpu temp

    # for backup mounts on bytemark servers
    package { "nfs-common": ensure => present }

    # Shells
    package { zsh: ensure => present } # for rafl
    package { byobu: ensure => present } # for mo

    # get version from https://packages.debian.org/wheezy-backports/tmux
    package { tmux:  ensure => '1.9-6~bpo70+1' } # from backports

    package { ack-grep: ensure => present }
    package { less: ensure => present }
    package { mosh: ensure => present }
    package { ncdu: ensure => present }
    package { tig: ensure => present }
    package { postgresql-server-dev-all: ensure => present }
    package { sqlite3: ensure => present }
    package { sudo: ensure => present }
    package { sysstat: ensure => present }
    package { tree: ensure => present }
    package { whois: ensure => present }

    package { ntp: ensure => present }
    # package { exim: ensure => present } # TODO: FIX

    # Stuff for firewall / security
    package { chkrootkit: ensure => present }
    package { iptables: ensure => installed }
    package { iptables-persistent: ensure => present }

    # Euuu - nasty, remove
    package { nano: ensure => absent }

    # updatedb was chewing up IO and we don't use it
    package { locate: ensure => absent }

    package{ build-essential: ensure => present }

    # For accessing postgress from psql
    package{ 'postgresql-client-9.6': ensure => present }
    Package{ provider => apt }

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
