class metacpan::system::rsyslog::server(

) {

  class { '::rsyslog::server':
    enable_tcp                => true,
    enable_udp                => false,
    enable_relp               => false,
    enable_onefile            => false,
    server_dir                => '/mnt/lv-metacpan--tmp/rsyslog_server/',
    custom_config             => 'metacpan/rsyslog/server-metacpan.conf.erb',
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

  # Grab the Perl version in use
  $perl_version = hiera('perl::version', '5.22.2')

  # Perl Modules for the eris logging system
  perl::module {
    [
      'eris', 'POE::Component::Client::eris', 'POE::Component::Server::eris'
    ]:
  }

  # Install the wrapper to get the write Perl's
  file {
    "/usr/local/sbin/rsyslog-eris-bridge":
      content => "#!/bin/sh\n/opt/perl-$perl_version/bin/perl /opt/perl-$perl_version/bin/eris-dispatcher-stdin.pl\n"
      mode    => "0555",
      notify  =>  Service['rsyslog'];
  }
}

