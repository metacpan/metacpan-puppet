class ossec(
  $role               = hiera('ossec::role'),
  $server_ip          = hiera('ossec::server_ip'),
  $email_alert_level  = hiera('ossec::email_alert_level'),
  $email_from         = hiera('ossec::email_from'),
  $email_to           = hiera('ossec::email_to'),
  $email_notification = hiera('ossec::email_notification'),
  $ip_whitelist       = hiera_array('ossec::ip_whitelist',[]),
  $logfiles           = hiera_array('ossec::logfiles',[]),
  $smtp_server        = heira('ossec::smtp_server'),
  $zeromq_output      = heira('ossec::zeromq_output'),
  $zeromq_uri         = heira('ossec::zeromq_uri'),
) {
  # Apt Source
  apt::source {
    'atomic':
      location => 'https://updates.atomicorp.com/channels/ossec/debian/',
      comment  => 'Atomic Rocket Turtle Open Source Repository',
      repos    => 'main',
      include  => {
        'src' => false,
        'deb' => true,
      },
      # TODO: Fix, key is borked
      #key      =>  {
      #  'id'     => 'FFBD5D0A4520AFA9',
      #  'source' => "https://updates.atomicorp.com/channels/ossec/debian/dists/${$facts['lsbdistcodename']}/Release.gpg"
      #},
  }

  # Install the Package
  $package = "ossec-hids-$role"
  package {
    "$package":
      ensure  => latest,
      require => Apt::Source['atomic'];
  }

  # Config file
  file {
    '/var/ossec/etc/ossec.conf':
      owner   => 'root',
      group   => 'ossec',
      content => template("ossec/$role.conf.erb"),
      notify  => Service['ossec'],
      require => Package["$package"];
  }

  if( $role == "server" ) {
    # Server Specific Configs
    file {
      '/var/ossec/rules/local_rules.xml':
        source  => 'puppet:///modules/ossec/local_rules.xml',
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        notify  => Service['ossec'],
        require => Package["$package"];
			'/var/ossec/rules/overwrite_rules.xml':
        source  => 'puppet:///modules/ossec/overwrite_rules.xml',
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        notify  => Service['ossec'],
        require => Package["$package"];
    }
    service {
      "ossec-authd":
        ensure => 'running',
        enable => true,
    }
  }
  else {
    # Clients configuration
    exec {
      # Create a key
      "ossec-client-auth":
        command => "/var/ossec/bin/agent-auth -m $server_ip",
        creates => '/var/ossec/etc/client.keys',
        notify => Service["ossec"];
    }
  }

  ## Setup the Firewall
  class {
    "ossec::firewall":
      role => $role;
  }

  ## Start/Run the Service
  service {
    'ossec':
      ensure => 'running',
      enable =>  true,
  }
}
