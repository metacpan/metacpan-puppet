# === Definition metacpan::web::twiggy
#
# In Hiera:
#
#   metacpan::twiggy::sites:
#     www:
#       git_source: 'https://github.com/CPAN-API/metacpan-puppet.git'
#       git_revision: 'master'
#       git_identity: '/home/user/.ssh/id_dsa'
#
#
define metacpan::web::twiggy (
    $owner = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
    $enable   = false,
    $git_source   = 'UNSET',
    $git_revision = 'master',
    $git_identity = 'UNSET',
) {

  $root = "/home/${owner}/${name}"

  if( $enable == true ) {
    metacpan::gitrepo{ "gitrepo_${name}":
      enable_git_repo   => $git_enable,
      path              => $root,
      source            => $git_source,
      revision          => $git_revision,
      owner             => $owner,
      group             => $group,
      identity          => $git_identity,
    }

    carton::run { $name:
      root => $root,
    }

  }

}
