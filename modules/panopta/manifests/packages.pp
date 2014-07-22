class panopta::packages() {

  exec { "apt-get update":
      command => "/usr/bin/apt-get update",
  }

  package{ "panopta_agent":
    require  => [ File['/etc/apt/sources.list.d/panopta'], Exec['apt-get update'] ],
  }

}
