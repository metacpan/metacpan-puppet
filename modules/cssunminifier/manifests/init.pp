class cssunminifier {

  include npm

  exec { "cssunminifier":
    command => "npm install -g cssunminifier",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    cwd => "/tmp",
    onlyif => "test ! -f /usr/local/bin/cssunminifier",
    require => [ Exec["npm"] ]
  }

}
