# === Definition metacpan::gitrepo
#
# In Hiera:
#
#   metacpan::gitrepos:
#     metacpan-puppet:
#       path: '/home/metacpan/metacpan.org'
#       source: 'https://github.com/CPAN-API/metacpan-puppet.git'
#       revision: 'master'
#       owner: 'metacpan'
#       group: 'metacpan'
#       identity: '/home/user/.ssh/id_dsa'
#
#
define metacpan::gitrepo (
    $ensure   = absent,
    $path     = 'UNSET',
    $source   = 'UNSET',
    $revision = 'UNSET',
    $owner    = 'metacpan',
    $group    = 'metacpan',
    $identity = 'UNSET',
) {

  if($ensure == 'present') {

    # create the directory first incase owner does not have permissions
    file { $path:
        ensure => directory,
        owner   => $owner,
        group   => $group,
        mode    => '0775',
        require => [ User[$owner] ],
    }

    if $revision == 'UNSET' {

        vcsrepo { $path:
            ensure   => $ensure,
            provider => git,
            source   => $source,
            user     => $owner,
            owner    => $owner,
            group    => $group,
#            identity => $identity ? ,
        }

    } else {

        vcsrepo { $path:
            ensure   => $ensure,
            provider => git,
            source   => $source,
            revision => $revision,
            user     => $owner,
            owner    => $owner,
            group    => $group,
#            identity => $identity,
        }

    }
  }
}
