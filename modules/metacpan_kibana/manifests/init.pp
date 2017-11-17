class metacpan_kibana() {

  include metacpan_kibana::package

  service { "kibana":
    ensure     => 'running',
    require => Exec['kibana_deb_install'],
  }

}

