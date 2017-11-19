class metacpan_elasticsearch(
) {

  include metacpan_elasticsearch::curator
  include metacpan_elasticsearch::firewall
  #include metacpan_elasticsearch::instance

  $script = hiera_hash('metacpan::elasticsearch::scripts', {})
  create_resources('metacpan_elasticsearch::script', $script)

}
