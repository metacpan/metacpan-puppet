class startserver::environment {
    include perlbrew
    perlbrew::install_module { ["Net::Server::SS::PreFork", "Server::Starter", "Starman"]:
        perl => $metacpan::perl,
    }

    file { "/var/run/startserver":
        ensure => directory,
        mode => 0777,
    }
}
