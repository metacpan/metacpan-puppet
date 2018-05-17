# Setup various system resources for metacpan.
class metacpan::logstash(
  $status = hiera('metacpan::logstash::status'),
) {

    apt::pin { 'logstash':
        version   => '1.4.2-1-2c0f5a1',
        priority  => 1001,
        packages  => 'logstash'
    }

    class { '::logstash':
       status => $status,
       package_url => 'https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb',
       #install_contrib => true,
       #contrib_package_url => 'https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash-contrib_1.4.2-1-efd53ef_all.deb',
    }

}
