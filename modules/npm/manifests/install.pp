define npm::install (
  $pkg = $name,
  $exe = $name,
) {

  include npm

  exec { "npm install -g $pkg":
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    cwd     => '/tmp',
    # This is naive but sufficient for our current usage.
    # We may have to check `npm list` at some point.
    unless  => "test -f /usr/local/bin/$exe",
    require => [
      Class['npm'],
    ],
  }

}
