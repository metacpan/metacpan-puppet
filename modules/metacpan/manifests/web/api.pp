class metacpan::web::api (
    # FIXME: This $apiworkers var is set in the node manifest.
    # FIXME: Make this a sensible default and override with hiera.
    $workers = $apiworkers,
) {
	nginx::vhost { "api.metacpan.org":
		bare => true,
		ssl  => true,
		aliases => ["api.$hostname.metacpan.org", "api.lo.metacpan.org", "st.aticpan.org", "api.beta.metacpan.org"],
	}

	nginx::proxy { "api-root":
		target   => "http://localhost:5000/",
		vhost    => "api.metacpan.org",
		location => "",
	}

	nginx::proxy { "api-v0":
		target   => "http://localhost:5000/",
		vhost    => "api.metacpan.org",
		location => "/v0",
	}

    $app_root = '/home/metacpan/api.metacpan.org'

    $old_service = 'metacpan-api'
    startserver::remove { $old_service: }

    # NOTE: The www service uses this $service var:
    $service = 'api-metacpan-org'

    # $perlbin isn't needed because the script sources the metacpanrc file.
    daemon_control { $service:
        root    => $app_root,
        port    => 5000,
        workers => $workers,
        require => [
            # Ensure the old service removes itself so we can use the port.
            Startserver::Remove[$old_service],
            # API needs ES.
            Service[ 'elasticsearch' ],
        ],
    }
}
