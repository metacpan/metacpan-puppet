# === Definition metacpan::web::starman
#
# In Hiera:
#
#   metacpan::web::docker:
#
#
define metacpan::web::docker (

    # nginx
    $vhost_aliases, # Required as main domain now here
    $vhost_html = '',
    $vhost_ssl_only = false,
    $vhost_ssl = $vhost_ssl_only,

    $vhost_extra_proxies = {},
    $vhost_extra_configs = {},

    # docker port
    $docker_port = 'UNSET',
) {

  metacpan_nginx::vhost { $name:
    html      => $vhost_html,
    ssl       => $vhost_ssl,
    ssl_only  => $vhost_ssl_only,
    bare      => true, 
    aliases   => $vhost_aliases,
  }

  # Add all the extra proxy / config gumpf
  create_resources('metacpan_nginx::proxy', $vhost_extra_proxies, {
    target   => "http://localhost:${docker_port}/",
    site    =>  $name,
    location => '',
  })

  create_resources('metacpan::web::nginx_extra_confs', $vhost_extra_configs, {
    site    =>  $name,
  })

  # Setup rev-proxy to starman
  metacpan_nginx::proxy { "proxy_${name}":
      target   => "http://localhost:${docker_port}/",
      site    => $name,
      location => '',
  }

}
