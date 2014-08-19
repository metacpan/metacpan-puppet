# === Definition metacpan::website
#
# In Hiera:
#
#   metacpan::website:
#     www:
#       path: '/home/metacpan/metacpan.org'
#       git_source: 'https://github.com/CPAN-API/metacpan-puppet.git'
#       git_revision: 'master'
#       owner: 'metacpan'
#       group: 'metacpan'
#       git_identity: '/home/user/.ssh/id_dsa'
#
#
define metacpan::website (
    $path     = 'UNSET',
    $owner    = 'metacpan',
    $group    = 'metacpan',
    $workers = 0,
    $git_enable   = false,
    $git_source   = 'UNSET',
    $git_revision = 'UNSET',
    $git_identity = 'UNSET',
    $vhost_domain = 'UNSET',
    $vhost_html = '',
    $vhost_ssl_only = false,
    $vhost_ssl = $vhost_ssl_only,
    $vhost_autoindex = false,
    $vhost_bare = false,
    $vhost_aliases = [],
) {

  if( $git_enable == 'true' ) {
    metacpan::gitrepo{ "gitrepo_${name}":
      enable_git_repo   => $git_enable,
      path              => $path,
      source            => $git_source,
      revision          => $git_revision,
      owner             => $owner,
      group             => $group,
      identity          => $git_identity,
    }
  }

  nginx::vhost { $vhost_domain:
    html      => $vhost_html,
    ssl       => $vhost_ssl,
    ssl_only  => $vhost_ssl_only,
    bare      => $vhost_bare,
    autoindex => $vhost_autoindex,
    aliases   => $vhost_aliases,
  }



}
