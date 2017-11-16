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

  # Create the directory for our JSON goodness
  file {
    '/var/log/metacpan':
      ensure => 'directory',
      mode   =>  '0755',
  }

  # Enable the local message files
  rsyslog::snippet {
    'metacpan-apps':
      content => ":programname,isequal,\"metacpan-web\" /var/log/metacpan/web.log\n:programname,isequal,\"metacpan-api\" /var/log/metacpan/api.log\n",
      require => File["/var/log/metacpan"],
  }

  # Rotate the logs
  logrotate::rule { 'metacpan-apps':
    path         => '/var/log/metacpan/*.log',
    copytruncate => true,
    missingok    => true,
    rotate_every => 'day',
    rotate       => '7',
    compress     => true,
    ifempty      => true,
  }
}

