class metacpan::system::rsyslog::myserver(

) {

  class { '::rsyslog::server':
    enable_tcp                => true,
    enable_udp                => false,
    enable_relp               => false,
    enable_onefile            => false,
    server_dir                => '/tmp/rsyslog_server/',
    custom_config             => undef,
    port                      => '514',
#    relp_port                 => '20514',
    address                   => '*',
    high_precision_timestamps => false,
    log_templates             => false,
    log_filters               => false,
    actionfiletemplate        => false,
    ssl_ca                    => '/etc/rsyslog.d/ca.crt',
    ssl_cert                  => '/etc/rsyslog.d/server.crt',
    ssl_key                   => '/etc/rsyslog.d/server.key',
    rotate                    => undef
  }

}

