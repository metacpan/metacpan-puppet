class metacpan_kibana() {

  include metacpan_kibana::package

    apt::pin { 'kibana':
        version   => '4.6.3',
        priority  => 1001,
        packages  => 'kibana'
    }


  Unpacking kibana (6.2.4) over (4.6.3) ...

  service { "kibana":
    ensure     => 'running',
    require => Exec['kibana_deb_install'],
  }

}

