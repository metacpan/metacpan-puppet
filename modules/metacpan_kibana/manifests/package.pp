class metacpan_kibana::package() {

  exec { "kibana_deb_download":
    command => "wget -O /opt/kibana-4.6.3-${::architecture}.deb https://download.elastic.co/kibana/kibana/kibana-4.6.3-${::architecture}.deb",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 600, # 10 min
    cwd => "/tmp",
    onlyif => "test ! -f /opt/kibana-4.6.3-${::architecture}.deb"
  }

  exec { "kibana_deb_install":
    command => "dpkg -i /opt/kibana-4.6.3-${::architecture}.deb",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    onlyif => "test ! -f /opt/kibana/bin/kibana",
    require => Exec['kibana_deb_download'],
  }



}
