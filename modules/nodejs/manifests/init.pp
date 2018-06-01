class nodejs {

  exec { "nodejs":
    command => "wget http://nodejs.org/dist/v0.12.18/node-v0.12.18.tar.gz && tar -xzf node-v0.12.18.tar.gz && cd node-v0.12.18 && ./configure && make install",
    path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 600, # 10 min
    cwd => "/tmp",
    onlyif => "test ! -f /usr/local/bin/node"
  }

}
