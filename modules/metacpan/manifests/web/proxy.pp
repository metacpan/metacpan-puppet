# === Definition metacpan::web::proxy
#
# In Hiera:
#
#   metacpan::web::proxy:
#
#
define metacpan::web::proxy (
    # nginx
    $vhost_aliases, # Required as main domain now here
    $vhost_html = '',
    $vhost_ssl_only = false,
    $vhost_ssl = $vhost_ssl_only,
    $vhost_autoindex = false,
    $vhost_bare = false,
    $vhost_extra_proxies = {},
    $vhost_extra_configs = {},

    $proxy_port = 'UNSET',
) {
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
    target   => "http://localhost:${proxy_port}/",
    site    =>  $name,
    location => '',
  })

  create_resources('metacpan::web::nginx_extra_confs', $vhost_extra_configs, {
    site    =>  $name,
  })

  # Setup rev-proxy to starman
  metacpan_nginx::proxy { "proxy_${name}":
      target   => "http://localhost:${proxy_port}/",
      site    => $name,
      location => '',
  }
}
