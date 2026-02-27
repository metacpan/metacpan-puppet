# Temporary: remove once all hosts have been cleaned up.
class metacpan::elasticsearch_volume_cleanup {
  mount { '/mnt/lv-elasticsearch':
    ensure => absent,
  }

  exec { 'remove-elasticsearch-lv':
    command => '/sbin/lvremove -f /dev/vg-ssds/elasticsearch',
    onlyif  => '/sbin/lvdisplay /dev/vg-ssds/elasticsearch',
    require => Mount['/mnt/lv-elasticsearch'],
  }
}
