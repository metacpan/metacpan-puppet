class { 'nodejs': }

define npm::install (
  $pkg = $name,
  $exe = $name,
) {
  exec { "npm install -g $pkg":
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    cwd     => '/tmp',
  }
}
