class panopta::apt() {

  # get package list
  file{
    "/etc/apt/sources.list.d/panopta.list":
    content => "deb http://packages.panopta.com/deb stable main";
  }

  # Sort out the key
  exec { "panopta_key":
      command => "/usr/bin/wget -O - http://packages.panopta.com/panopta.pub | /usr/bin/apt-key add -
",
      unless => "/usr/bin/apt-key list | /bin/grep panopta",
      require => File['/etc/apt/sources.list.d/panopta.list'],
  }

  exec { "panopta_update":
      command => "/usr/bin/apt-get update",
      # ok, so it doesn't create this, but if we have it we don't
      # need to do this update, so make it quicker!
      creates => '/usr/bin/panopta-agent/panopta_agent.py',
      require => [ Exec['panopta_key'] ],
  }

}
