class metacpan::web::api {
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

    # NOTE: Config for workers and port are set in bin/daemon-control.pl.
    # $perlbin isn't needed because the script sources the metacpanrc file.
    daemon_control { $service:
        root    => $app_root,
        require => [
            # Ensure the old service removes itself so we can use the port.
            Startserver::Remove[$old_service],
            # API needs ES.
            Service[ 'elasticsearch' ],
        ],
    }
}
