class metacpan::system::packages {

    # Editors
    package { 'vim': ensure => present }

    # Docker Stuff
    package { 'docker': ensure => present }
    package { 'docker-compose': ensure => present }

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
    package { apt-transport-https: ensure => present } # for ES repo

    # for monitoring
    # https://debian-administration.org/article/327/Monitoring_your_hardware's_temperature
    package { lm-sensors: ensure => present } # sensors cmd for cpu temp

    # for backup mounts on bytemark servers
    package { "nfs-common": ensure => present }

    # Shells
    package { zsh: ensure => present } # for rafl
    package { byobu: ensure => present } # for mo

    package { libpcre3: ensure => present } # for gitgrep in grep.mc.org
    package { libpcre3-dev: ensure => present } # for gitgrep in grep.mc.org
    package { gettext: ensure => present } # for gitgrep in grep.mc.org

    package { ack-grep: ensure => present }
    package { less: ensure => present }
    package { mosh: ensure => present }
    package { ncdu: ensure => present }
    package { tig: ensure => present }
    package { postgresql-server-dev-all: ensure => present }
    package { sqlite3: ensure => present }
    package { sudo: ensure => present }
    package { sysstat: ensure => present }
    package { tmux:  ensure => '2.7-1~bpo9+1' } # back ports
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
