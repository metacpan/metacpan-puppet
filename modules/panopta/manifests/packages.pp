class panopta::packages() {

  exec { "panopta_agent":
      command => "/usr/bin/apt-get install --assume-yes --allow-unauthenticated panopta-agent",
      creates => '/usr/bin/panopta-agent/panopta_agent.py',
      require  => [ Exec['panopta_update'] ],
  }

}
