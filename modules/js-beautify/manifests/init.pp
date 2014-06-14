class js-beautify {

  include npm

  exec { "js-beautify":
    command => "npm install -g js-beautify",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    cwd => "/tmp",
    onlyif => "test ! -f /usr/local/bin/js-beautify",
    require => [ Exec["npm"] ]
  }

}
