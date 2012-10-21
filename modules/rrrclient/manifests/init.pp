define rrrclient(
    $perl,
    $owner = $name,
    $target = "/home/$name/CPAN",
    $pid_file = "/var/run/rrrclient-$name.pid",
) {
    include perlbrew
    perlbrew::install_module { "File::Rsync::Mirror::Recent":
        perl => $perl,
    }

    $path = "$perlbrew::params::perlbrew_root/perls/$perl/bin"
    $bin = "$path/rrr-client"
    $filename = "rrrclient-$name"
    $description = "Startup script for rrr-client ($name)"
    file { "/etc/init.d/$filename":
        ensure => file,
        mode   => 0755,
        content => template("rrrclient/init.erb"),
        require => File[$target],
    }
}
