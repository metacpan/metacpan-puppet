# === Definition swat
#
# In Hiera:
#
#   metacpan::system::swat:
#     metacpan-monitoring:
#       enable: true
#       git_revision: 'master'
#
#
define metacpan::system::swat (
    $owner = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
    $git_revision = 'master',
    $enable = false,
) {


  $path = "/home/${owner}/${name}"

  if( $enable == true ) {
    metacpan::gitrepo{ "gitrepo_${name}":
      enable_git_repo   => true,
      path              => $path,
      source            => 'https://github.com/CPAN-API/metacpan-monitoring.git',
      revision          => $git_revision,
      owner             => $owner,
      group             => $group,
      ensure            => latest, # force update

      # Should tell carton to run
      notify            => [
           Carton::Run[$name],
      ],
      require => [ Metacpan::User[$owner] ],

    }
  }
  carton::run { $name:
    root => $path,
  }

  # Cron



}
