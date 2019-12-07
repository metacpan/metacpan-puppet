class metacpan::system::rsyslog::server(
    $server_dir                = '/mnt/lv-metacpan--tmp/rsyslog_server/',
    $logdir_symlink            =  '/var/log/remote',
) {

  class { '::rsyslog::server':
    enable_tcp                => true,
    enable_udp                => false,
    enable_relp               => false,
    enable_onefile            => false,
    server_dir                => $server_dir,
    custom_config             => 'metacpan/rsyslog/server-metacpan.conf.erb',
    port                      => '514',
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
    'eris':
      version =>  '0.004';
    'Parse::Syslog::Line':
      version =>  '4.0';
    'POE::Component::Server::eris':
      version =>  '2.3';
    # Modules where version isn't important
     [
       'POE::Component::Client::eris'
     ]:
  }

  # Install the wrapper to get the write Perl's
  file {
    "/usr/local/sbin/rsyslog-eris-bridge":
      content => "#!/bin/sh\n/opt/perl-$perl_version/bin/perl /opt/perl-$perl_version/bin/eris-dispatcher-stdin.pl\n",
      mode    => '0555',
      notify  =>  Service['rsyslog'];
  }

  # Handles the remote log storage and rotation
  file {
    # Drop a symlink somewhere that makes more sense
    "$logdir_symlink":
      ensure => 'link',
      target => "$server_dir";
    # Rotate logs
    "/etc/logrotate.d/central_logger":
      source => "puppet:///modules/metacpan/rsyslog_server/logrotate.d/central_logger",
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
  }
}

