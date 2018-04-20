class metacpan_elasticsearch::firewall(
    $env = hiera('metacpan::elasticsearch::env','production'),
) {

  if($env == 'dev') {

    firewall{ "300 Elasticsearch private transport":
      ensure  => present,
      dport   => [ 9200, 9300, 9900 ],
      proto   => tcp,
      action  => 'accept',
      source  => "0.0.0.0/0",  # Anyone
    }


  } else {
    # Production
    $local_net = hiera_array('metacpan::elasticsearch::cluster_hosts', [])

    # Add each other server in the cluster, no access to anything
    # outside of this.
    $local_net.each |$source| {

      firewall{ "300 Elasticsearch private transport for ${source} - ${name} (${module})":
        ensure  => present,
        dport   => [ 9200, 9300 ],
        proto   => tcp,
        action  => 'accept',
        source  => "${source}/32",
      }

    }

  }



}
