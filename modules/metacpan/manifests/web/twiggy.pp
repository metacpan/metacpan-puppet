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
    $git_enable   = false,
    $git_source,
    $git_revision = 'master',
    $twiggy_port,
) {

  $path = "/home/${owner}/${name}"

  if( $git_enable == true ) {
    metacpan::gitrepo{ "gitrepo_${name}":
      enable_git_repo   => $git_enable,
      path              => $path,
      source            => $git_source,
      revision          => $git_revision,
      owner             => $owner,
      group             => $group,
      ensure            => latest, # force update

      notify            => [
           Carton::Run[$name],
           Twiggy::Service[$name],
      ],
      require => [ Metacpan::User[$owner] ],
    }
  }

  # nginx is handled by the api

  twiggy::service { $name:
      root    => $path,
      port    => $twiggy_port,
  }


}
