class metacpan_elasticsearch::test_instance(
  $version = hiera('metacpan::elasticsearch::version'),
  $autoupgrade = hiera('metacpan::elasticsearch::autoupgrade', true),
  $ensure = hiera('metacpan::elasticsearch::ensure', 'present'),
  $memory = hiera('metacpan::elasticsearch::memory', '64'),
  $ip_address = hiera('metacpan::elasticsearch::ipaddress', '127.0.0.1'),
  $data_dir = hiera('metacpan::elasticsearch::test_datadir', '/var/elasticsearch_test'),
  $env = hiera('metacpan::elasticsearch::env','dev'),
) {

  $cluster_hosts = hiera_array('metacpan::elasticsearch::cluster_hosts', [])

  $instance_name = 'dev-01'

  # Add the port for unicast to the IP addresses
  $cluster_hosts_with_transport_port = $cluster_hosts.map |$s| { "${s}:9950" }
  # Main port (used by marvel)
  $cluster_hosts_with_port = $cluster_hosts.map |$s| { "${s}:9900" }

  # Setup an actual running instance
  $init_hash = {
    'ES_USER' => 'elasticsearch',
    'ES_GROUP' => 'elasticsearch',
    # Set min/max to the same value (recommended by es).
    'ES_HEAP_SIZE' => $memory,
  }

  $network_host = "['${ipaddress}', 'localhost']";

  $config_hash_dev = {
    'http.port' => '9900',
    'network.host' => $network_host,

    'cluster.name' => 'dev-test',

    'index.search.slowlog.threshold.query.warn' => '10s',
    'index.search.slowlog.threshold.query.info' => '2s',
    'index.search.slowlog.threshold.fetch.warn' => '1s',

    'gateway.recover_after_nodes' => '1',
    'gateway.recover_after_time' => '2m',
    'gateway.expected_nodes' => '3',

    # only allow one node to start on each box
    'node.max_local_storage_nodes' => '1',

    # do not care about split brain on dev
    'discovery.zen.minimum_master_nodes' => '1',

    # Turn OFF multicast, and explisitly do only unicast to listed hosts
    'discovery.zen.ping.multicast.enabled' => false,
    'discovery.zen.ping.unicast.hosts' => $cluster_hosts_with_transport_port,

    'marvel.agent.exporter.es.hosts' => $cluster_hosts_with_port,

    # for now once a min, so we don't get too much data
    'marvel.agent.interval' => '60s',

    # Let marvel auto create indexes, but nothing else
    'action.auto_create_index' => '.marvel-*,logstash-*',

  }

  elasticsearch::instance { $instance_name:
    config => $config_hash_dev,
    init_defaults => $init_hash,
    datadir => $data_dir,
  }

}


