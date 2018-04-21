# === Definition metacpan::web::static
#
# In Hiera:
#
#   metacpan::web::static:
#
#
define metacpan::web::static (
    $owner = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),

    # git
    $git_enable   = false,
    $git_source   = 'UNSET',
    $git_revision = 'UNSET',
    $git_identity = 'UNSET',

    # nginx
    $vhost_aliases, # Required as main domain now here
    $vhost_html = '',
    $vhost_ssl_only = false,
    $vhost_ssl = $vhost_ssl_only,
    $vhost_autoindex = false,
    $vhost_bare = false,
    $vhost_extra_proxies = {},
    $vhost_extra_configs = {},

) {

  $path = "/home/${owner}/${name}"

  if( $git_enable == true ) {
    metacpan::gitrepo{ "gitrepo_${name}":
      ensure            => latest, # force update
      enable_git_repo   => $git_enable,
      path              => $path,
      source            => $git_source,
      revision          => $git_revision,
      owner             => $owner,
      group             => $group,
      identity          => $git_identity,
    }
  }

  metacpan_nginx::vhost { $name:
    html      => $vhost_html,
    ssl       => $vhost_ssl,
    ssl_only  => $vhost_ssl_only,
    bare      => $vhost_bare,
    autoindex => $vhost_autoindex,
    aliases   => $vhost_aliases,
  }

  create_resources('metacpan::web::nginx_extra_confs', $vhost_extra_configs, {
    site    =>  $name,
  })

}
