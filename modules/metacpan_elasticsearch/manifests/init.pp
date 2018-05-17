class metacpan_elasticsearch(
  $version = hiera('metacpan::elasticsearch::version'),
) {

  include metacpan_elasticsearch::curator
  include metacpan_elasticsearch::firewall
  include metacpan_elasticsearch::instance

  $script = hiera_hash('metacpan::elasticsearch::scripts', {})
  create_resources('metacpan_elasticsearch::script', $script)

  # Do not let apt upgrade us by mistake
  apt::pin { 'elasticsearch':
    version   => $version,
    priority  => 1001,
    packages  => 'elasticsearch'
  }

}
