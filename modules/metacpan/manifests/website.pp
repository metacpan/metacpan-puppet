# === Definition metacpan::website
#
# In Hiera:
#
#   metacpan::website:
#     www:
#       path: '/home/metacpan/metacpan.org'
#       source: 'https://github.com/CPAN-API/metacpan-puppet.git'
#       revision: 'master'
#       owner: 'metacpan'
#       group: 'metacpan'
#       identity: '/home/user/.ssh/id_dsa'
#
#
define metacpan::website (
    $enable_git_repo   = false,
    $path     = 'UNSET',
    $source   = 'UNSET',
    $revision = 'UNSET',
    $owner    = 'metacpan',
    $group    = 'metacpan',
    $identity = 'UNSET',
    $workers = 0,
    $vhost_html = '',
    $vhost_ssl = false,
    $vhost_autoindex = false,
    $domain = 'UNSET',
) {

  if($enable_git_repo == 'true') {
    metacpan::gitrepo{ "gitrepo_${name}":
      enable_git_repo   => $enable_git_repo,
      path              => $path,
      source            => $source,
      revision          => $revision,
      owner             => $owner,
      group             => $group,
      identity          => $identity,
    }
  }

  nginx::vhost { $domain:
    html      => $vhost_html,
    ssl       => $vhost_ssl,
    autoindex => $vhost_autoindex,
    aliases   => ["cpan.$hostname.metacpan.org", "cpan.lo.metacpan.org"],
  }



}
