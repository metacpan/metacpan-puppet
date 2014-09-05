class panopta::packages() {

  exec { "apt-get update":
      command => "/usr/bin/apt-get update",
  }
  exec { "panopta_agent":
      command => "/usr/bin/apt-get install --assume-yes --allow-unauthenticated panopta-agent",
      creates => '/usr/bin/panopta-agent/panopta_agent.py',
      require  => [ File['/etc/apt/sources.list.d/panopta.list'], Exec['apt-get update'] ],
  }

}
