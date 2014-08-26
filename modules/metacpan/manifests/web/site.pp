# === Definition metacpan::website
#
# In Hiera:
#
#   metacpan::web::site:
#     www:
#       path: '/home/metacpan/metacpan.org'
#       git_source: 'https://github.com/CPAN-API/metacpan-puppet.git'
#       git_revision: 'master'
#       owner: 'metacpan'
#       group: 'metacpan'
#       git_identity: '/home/user/.ssh/id_dsa'
#
#
define metacpan::web::site (
    $path = 'UNSET',
    $owner = hiera('metacpan::user', 'metacpan'),
    $group = hiera('metacpan::group', 'metacpan'),
    $workers = 0,
    $git_enable   = false,
    $git_source   = 'UNSET',
    $git_revision = 'UNSET',
    $git_identity = 'UNSET',

    $vhost_aliases, # Required as main domain now here
    $vhost_html = '',
    $vhost_ssl_only = false,
    $vhost_ssl = $vhost_ssl_only,
    $vhost_autoindex = false,
    $vhost_bare = false,
    $vhost_extra_proxies = {},
    $vhost_extra_configs = {},

    $starman_port = 'UNSET',
    $starman_workers = 1,
) {


  if( $git_enable == true ) {
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

  nginx::vhost { $name:
    html      => $vhost_html,
    ssl       => $vhost_ssl,
    ssl_only  => $vhost_ssl_only,
    bare      => $vhost_bare,
    autoindex => $vhost_autoindex,
    aliases   => $vhost_aliases,
  }

  # Add all the extra proxy / config gumpf
  create_resources('nginx::proxy', $vhost_extra_proxies, {
    target   => "http://localhost:${starman_port}",
    site    =>  $name,
    location => '',
  })

  create_resources('metacpan::web::nginx_extra_confs', $vhost_extra_configs, {
    site    =>  $name,
  })

  if( $starman_port != 'UNSET' ) {
      # One or more proxies going on

      nginx::proxy { "proxy_${name}":
          target   => "http://localhost:${starman_port}",
          site    => $name,
          location => '',
      }

      starman::service { "starman_${name}":
          service => $name,
          root    => $path,
          port    => $starman_port,
          workers => $starman_workers,
      }
  }


}
