# === Definition metacpan::web::starman
#
# In Hiera:
#
#   metacpan::web::starman:
#
#
define metacpan::web::starman (
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

    # starman
    $starman_port = 'UNSET',
    $starman_workers = 1,
    $starman_init_template = 'starman/init.pl.erb',

    # allow overriding the nginx target
    $proxy_target_port = $starman_port,
    $service_enable    = true,

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
      identity          => $git_identity,
      ensure            => latest, # force update

      # Should tell carton to run and starman to restart
      notify            => [
           Carton::Run[$name],
           Starman::Service[$name],
      ],
      require => [ Metacpan::User[$owner] ],
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

  # Add all the extra proxy / config gumpf
  create_resources('metacpan_nginx::proxy', $vhost_extra_proxies, {
    target   => "http://localhost:${proxy_target_port}/",
    site    =>  $name,
    location => '',
  })

  create_resources('metacpan::web::nginx_extra_confs', $vhost_extra_configs, {
    site    =>  $name,
  })

  # Setup rev-proxy to starman
  metacpan_nginx::proxy { "proxy_${name}":
      target   => "http://localhost:${proxy_target_port}/",
      site    => $name,
      location => '',
  }

  starman::service { $name:
      root           => $path,
      port           => $starman_port,
      workers        => $starman_workers,
      init_template  => $starman_init_template,
      service_enable => $service_enable,
  }


}
