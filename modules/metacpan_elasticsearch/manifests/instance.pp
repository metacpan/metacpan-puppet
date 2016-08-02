class metacpan_elasticsearch::instance(
  $version = hiera('metacpan::elasticsearch::version'),
  $autoupgrade = hiera('metacpan::elasticsearch::autoupgrade', true),
  $ensure = hiera('metacpan::elasticsearch::ensure', 'present'),
  $memory = hiera('metacpan::elasticsearch::memory', '64'),
  $ip_address = hiera('metacpan::elasticsearch::ipaddress', '127.0.0.1'),
  $data_dir = hiera('metacpan::elasticsearch::datadir', '/var/elasticsearch'),
  $env = hiera('metacpan::elasticsearch::env','production'),
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

  # Install ES, but don't run
  class { 'elasticsearch':


    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${$version}.deb",
    java_install => true,
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


  # From: https://github.com/metacpan/metacpan-puppet/blob/36ea6fc4bacb457a03aa71343fee075a0f7feb97/modules/elasticsearch/templates/config/elasticsearch_yml.erb
  # For 0.20.x installs
  $config_hash_old = {
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

  $network_host = "['${ipaddress}', 'localhost']";

  # As recommended by clinton, for ES 1.4 as a cluster
  # This should really be via hiera or something
  $config_hash_cluster_production = {
    'http.port' => '9200',
    'network.host' => $network_host,

    'cluster.name' => 'bm',

    'index.search.slowlog.threshold.query.warn' => '10s',
    'index.search.slowlog.threshold.query.info' => '2s',
    'index.search.slowlog.threshold.fetch.warn' => '1s',

    'gateway.recover_after_nodes' => '2',
    'gateway.recover_after_time' => '2m',
    'gateway.expected_nodes' => '3',

    # only allow one node to start on each box
    'node.max_local_storage_nodes' => '1',

    # require at least two nodes to be able to see each other
    # this prevents split brains
    'discovery.zen.minimum_master_nodes' => '2',

    # Turn OFF multicast, and explisitly do only unicast to listed hosts
    'discovery.zen.ping.multicast.enabled' => false,
    'discovery.zen.ping.unicast.hosts' => $cluster_hosts_with_transport_port,

    'marvel.agent.exporter.es.hosts' => $cluster_hosts_with_port,

    # for now once a min, so we don't get too much data
    'marvel.agent.interval' => '60s',

    # Let marvel auto create indexes, but nothing else
    'action.auto_create_index' => '.marvel-*,logstash-*',

  }

  $config_hash_dev = {
    'http.port' => '9200',
    'network.host' => $network_host,

    'cluster.name' => 'dev',

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

  case $version {
    default : {
      case $env {
        default : {

          # Production
          $config_hash = $config_hash_cluster_production

          elasticsearch::plugin{'lmenezes/elasticsearch-kopf':
            instances  => $instance_name,
               #ensure => 'absent',
               ensure => 'present',
          }

        }
        'dev' : {

            $config_hash = $config_hash_dev

        }
      }
    }
    '0.20.2' : { $config_hash = $config_hash_old }
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

