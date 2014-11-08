class metacpan_elasticsearch::instance(
  $es_version = hiera('metacpan::elasticsearch::version'),
  $memory = hiera('metacpan::elasticsearch::memory', '64'),
  $data_dir = hiera('metacpan::elasticsearch::datadir', '/var/elasticsearch'),
) {

  $cluster_hosts = hiera_hash('metacpan::elasticsearch::cluser_hash')

  # Set ulimits
  file {
      "/etc/security/limits.d/elasticsearch":
          source => "puppet:///modules/metacpan_elasticsearch/etc/security/elasticsearch";
  }

  # Install ES, but don't run
  class { 'elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${es_version}.deb",
    java_install => true,
    # Defaults can be in here...
    config => { 'cluster.name' => 'bm' }
  }

  # Setup an actual running instance
  $init_hash = {
    'ES_USER' => 'elasticsearch',
    'ES_GROUP' => 'elasticsearch',
    # Set min/max to the same value (recommended by es).
    'ES_HEAP_SIZE' => $memory,
  }

  # From: https://github.com/CPAN-API/metacpan-puppet/blob/36ea6fc4bacb457a03aa71343fee075a0f7feb97/modules/elasticsearch/templates/config/elasticsearch_yml.erb
  $config_hash = {
    'network.host' => '127.0.0.1',
    'http.port' => '9200',

    'cluster.name' => 'bm',
    'cluster.routing.allocation.concurrent_recoveries' =>  '2',

    'index.translog.flush_threshold' => '20000',

    'index.search.slowlog.threshold.query.warn' => '10s',
    'index.search.slowlog.threshold.query.info' => '2s',
    'index.search.slowlog.threshold.fetch.warn' => '1s',

    'gateway.recover_after_nodes' => '1',
    'gateway.recover_after_time' => '2m',
    'gateway.expected_nodes' => '1',
    'gateway.local.compress' => 'false',
    'gateway.local.pretty' => 'true',

    'action.auto_create_index' => '0',

    'bootstrap.mlockall' => '1',
  }

  elasticsearch::instance { 'es-01':
    config => $config_hash,
    init_defaults => $init_hash,
    datadir => $data_dir,
  }

}
