class metacpan::system::rsyslog::client(
  $log_remote = hiera('metacpan::rsyslog::client::log_remote', false),
  $server = hiera('metacpan::rsyslog::client::server', 'bm-mc-03.metacpan.org'),
) {

  class { '::rsyslog::client':
    log_remote                => true,
    spool_size                => '1g',
    spool_timeoutenqueue      => false,
    remote_type               => 'tcp',
    remote_forward_format     => 'RSYSLOG_ForwardFormat',
    log_local                 => true,
    log_auth_local            => false,
    listen_localhost          => false,
    split_config              => false,
    # custom_config             => undef,
    # custom_params             => undef,
    port                      => '514',
    server                    => $server,
    remote_servers            => false,  # only log to the once above
    ssl_ca                    => '/etc/rsyslog.d/ca.crt',
    ssl_permitted_peer        => 'rsyslog.metacpan.org',
    ssl_auth_mode             => 'x509/name',
    log_templates             => false,
    log_filters               => false,
    actionfiletemplate        => false,
    high_precision_timestamps => false,
    rate_limit_burst          => undef,
    rate_limit_interval       => undef
  }

}

