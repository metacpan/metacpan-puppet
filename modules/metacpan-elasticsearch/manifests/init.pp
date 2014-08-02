class metacpan-elasticsearch(
  $es_version = hiera('elasticsearch::pkg_version', '1.3.1'),
  $memory = hiera('elasticsearch::memory', '64'),
) {

  # Install ES, but don't run
  class { 'elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${es_version}.deb",
    java_install => true,
    # Defaults can be in here...
    config => { 'cluster.name' => $env }
  }

  # Setup an actual running instance
  $init_hash = {
    'ES_USER' => 'elasticsearch',
    'ES_GROUP' => 'elasticsearch',
    'ES_MIN_MEM' => $memory,
    'ES_MAX_MEM' => $memory,
  }

  $config_hash = {
    'cluster.name' => $env
  }

  elasticsearch::instance { 'es-01':
    config => $config_hash,
    init_defaults => $init_hash,
    #datadir => [],       # Data directory
  }

}
