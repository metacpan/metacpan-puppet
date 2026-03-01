# Temporary: remove once all hosts have been cleaned up.
class metacpan::elasticsearch_volume_cleanup {
  mount { '/mnt/lv-elasticsearch':
    ensure => absent,
  }

  exec { 'remove-elasticsearch-lv-ssds':
    command => '/sbin/lvremove -f /dev/vg-ssds/elasticsearch',
    onlyif  => '/sbin/lvdisplay /dev/vg-ssds/elasticsearch',
    require => Mount['/mnt/lv-elasticsearch'],
  }

  exec { 'remove-elasticsearch-lv-hdds':
    command => '/sbin/lvremove -f /dev/vg-hdds/elasticsearch',
    onlyif  => '/sbin/lvdisplay /dev/vg-hdds/elasticsearch',
    require => Mount['/mnt/lv-elasticsearch'],
  }
}
