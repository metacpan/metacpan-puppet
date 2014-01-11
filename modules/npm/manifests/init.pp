class npm {

  include nodejs

  exec { "npm":
    command => "curl https://npmjs.org/install.sh | sh",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    cwd => "/tmp",
    onlyif => "/usr/bin/test !-f /usr/local/bin/npm",
    require => [ Exec["nodejs"] ]
  }

}