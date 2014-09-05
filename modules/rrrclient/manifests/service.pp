define rrrclient::service(
    $owner = $name,
    $cpan_mirror,
    $pid_file = "/var/run/rrrclient-$name.pid",
    $enable = false,
) {
    include perl
    perl::module{'File-Rsync-Mirror-Recent':
      module => 'File::Rsync::Mirror::Recent'
    }

    $path = "$perl::params::bin_dir"
    $bin = "${path}/rrr-client"
    $filename = "rrrclient-${name}"
    $description = "Startup script for rrr-client (${name})"

    file { "/etc/init.d/$filename":
        ensure => file,
        mode   => 0755,
        content => template("rrrclient/init.erb"),
        require => File[$cpan_mirror],
    }

    service { "rrrclient-metacpan":
      ensure => $enable ? {
          true => running,
          false => stopped,
      },
      enable => $enable,
    }

    rrrclient::cron { "foo":
      ensure => $enable ? {
          true => present,
          default => absent,
      },
      cpan_mirror => $cpan_mirror
    }

}
