class metacpan_elasticsearch::firewall(
) {

  $local_net = hiera_array('metacpan::elasticsearch::cluster_hosts', [])

  # Add each other server in the cluster, no access to anything
  # outside of this.
  $local_net.each |$source| {

    firewall{ "300 Elasticsearch private transport for ${source} - ${name} (${module})":
      ensure  => present,
      port    => [ 9200, 9300 ],
      proto   => tcp,
      action  => 'accept',
      source  => "${source}/32",
    }

  }

}
