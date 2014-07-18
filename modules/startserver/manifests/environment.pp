class startserver::environment {

    # Probably could be in carton?
    perl::module{'Starman':
      module => 'Starman'
    }
    perl::module{'NetServerSSPreFork':
      module => 'Net::Server::SS::PreFork'
    }
    perl::module{'ServerStarter':
      module => 'Server::Starter'
    }

    file { "/var/run/startserver":
        ensure => directory,
        mode => 0777,
    }
}
