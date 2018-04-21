class metacpan_elasticsearch::instance(
  $version = hiera('metacpan::elasticsearch::version'),
  $autoupgrade = hiera('metacpan::elasticsearch::autoupgrade', true),
  $ensure = hiera('metacpan::elasticsearch::ensure', 'present'),
  $memory = hiera('metacpan::elasticsearch::memory', '64'),
  $ip_address = hiera('metacpan::elasticsearch::ipaddress', '127.0.0.1'),
  $data_dir = hiera('metacpan::elasticsearch::datadir', '/var/elasticsearch'),
  $cluster_name = hiera('metacpan::elasticsearch::cluster_name','bm'),
  $number_of_shards     = hiera('metacpan::elasticsearch::shards',1),
  $number_of_replicas   = hiera('metacpan::elasticsearch::replicas',2),
  $minimum_master_nodes = hiera('metacpan::elasticsearch::master_nodes',2),
  $recover_after_nodes  = hiera('metacpan::elasticsearch::recover_after_nodes',3),
  $recover_after_time   = hiera('metacpan::elasticsearch::recover_after_time','3m'),
  $expected_nodes       = hiera('metacpan::elasticsearch::expected_nodes','3'),
  $auto_create_indexes  = hiera('metacpan::elasticsearch::auto_create_indexes','.marvel-*,logstash-*'),
) {

  $cluster_hosts = hiera_array('metacpan::elasticsearch::cluster_hosts', [])

  $instance_name = 'es-01'

  # Add the port for unicast to the IP addresses
  $cluster_hosts_with_transport_port = $cluster_hosts.map |$s| { "${s}:9300" }
  # Main port (used by marvel)
  $cluster_hosts_with_port = $cluster_hosts.map |$s| { "${s}:9200" }

  # Set ulimits
  file {
      "/etc/security/limits.d/elasticsearch":
          source => "puppet:///modules/metacpan_elasticsearch/etc/security/elasticsearch";
  }

  include ::java

  # Install ES, but don't run
  class { 'elasticsearch':

    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${$version}.deb",
    autoupgrade => $autoupgrade,
    ensure => $ensure,
    # Defaults can be in here...
    config => { 'cluster.name' => 'bm' }
  }

  # Setup an actual running instance
  $init_hash = {
    'ES_USER' => 'elasticsearch',
    'ES_GROUP' => 'elasticsearch',
    # Set min/max to the same value (recommended by es).
    'ES_HEAP_SIZE' => $memory,
    'ES_MIN_MEM' => $memory,
    'ES_MAX_MEM' => $memory,
  }


  $network_host = '0.0.0.0';

  # As recommended by clinton, for ES 1.4 as a cluster
  # This should really be via hiera or something
  $config_hash = {
    'http.port' => '9200',
    'network.host' => $network_host,

    'cluster.name' => $cluster_name,

    'index.number_of_replicas' => $number_of_replicas,
    'index.number_of_shards' => $number_of_shards,

    'index.search.slowlog.threshold.query.warn' => '10s',
    'index.search.slowlog.threshold.query.info' => '2s',
    'index.search.slowlog.threshold.fetch.warn' => '1s',

    'gateway.recover_after_nodes' => $recover_after_nodes,
    'gateway.recover_after_time'  => $recover_after_time,

    'gateway.expected_nodes' => $expected_nodes,

    # only allow one node to start on each box
    'node.max_local_storage_nodes' => '1',

    # require at least two nodes to be able to see each other
    # this prevents split brains
    'discovery.zen.minimum_master_nodes' => $minimum_master_nodes,

    # Turn OFF multicast, and explisitly do only unicast to listed hosts
    'discovery.zen.ping.multicast.enabled' => false,
    'discovery.zen.ping.unicast.hosts' => $cluster_hosts_with_transport_port,

    'marvel.agent.exporter.es.hosts' => $cluster_hosts_with_port,

    # for now once a min, so we don't get too much data
    'marvel.agent.interval' => '60s',

    # Let marvel auto create indexes, but nothing else
    'action.auto_create_index' => $auto_create_indexes,

  }

  elasticsearch::plugin{'lmenezes/elasticsearch-kopf':
    instances  => $instance_name,
       #ensure => 'absent'
       ensure => 'present',
  }

  # elasticsearch::plugin{'royrusso/elasticsearch-HQ':
  #   instances  => $instance_name,
  #      ensure => 'present',
  # }

  elasticsearch::plugin{'cloud-aws':
    instances  => $instance_name,
       #ensure => 'absent',
       ensure => 'present',
  }

  elasticsearch::instance { $instance_name:
    config => $config_hash,
    init_defaults => $init_hash,
    datadir => $data_dir,
  }

}


#       elasticsearch::plugin{ 'license':
#           instances  => $instance_name,
#           # PITA when upgrading, so disable and remove first
# #          ensure => 'absent',
#            ensure => 'present',
#       }

#       elasticsearch::plugin{ 'marvel-agent':
#           instances  => $instance_name,
#           # PITA when upgrading, so disable and remove first
# #          ensure => 'absent',
#            ensure => 'present',
#       }

