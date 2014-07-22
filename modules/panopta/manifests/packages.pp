class panopta::packages() {

  exec { "apt-get update":
      command => "/usr/bin/apt-get update",
  }

  package{ "panopta-agent":
    require  => [ File['/etc/apt/sources.list.d/panopta.list'], Exec['apt-get update'] ],
  }

}
