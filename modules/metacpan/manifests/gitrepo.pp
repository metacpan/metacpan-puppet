# === Definition metacpan::gitrepo
#
# In Hiera:
#
#   metacpan::website:
#     www:
#       enable_git_repo: true
#       path: /home/%{hiera('metacpan::user')}/metacpan.org
#       source: 'https://github.com/CPAN-API/metacpan-web.git'
#       revision: 'master' # optional
#       owner: 'metacpan' # default
#       group: 'metacpan' # default
#
#
define metacpan::gitrepo (
    $enable_git_repo   = false,
    $path     = 'UNSET',
    $source   = 'UNSET',
    $revision = 'master',
    $owner    = 'metacpan',
    $group    = 'metacpan',
    $identity = 'UNSET',
) {

  if($enable_git_repo == true) {

    # create the directory first incase owner does not have permissions
    file { $path:
        ensure => directory,
        owner   => $owner,
        group   => $group,
        mode    => '0775',
        require => [ User[$owner] ],
    }

    vcsrepo { $path:
        ensure   => $ensure,
        provider => git,
        source   => $source,
        revision => $revision,
        user     => $owner,
        owner    => $owner,
        group    => $group,
#       identity => $identity,
    }
  }
}
