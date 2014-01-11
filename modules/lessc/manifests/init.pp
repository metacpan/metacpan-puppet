class lessc {

  include npm

  exec { "lessc":
    command => "npm install -g less",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    cwd => "/tmp",
    onlyif => "/usr/bin/test !-f /usr/local/bin/lessc",
    require => [ Exec["npm"] ]
  }

}