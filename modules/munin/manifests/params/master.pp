# Parameters for the munin::master class. Add support for new OS
# families here.
class munin::params::master {
  $message = "Unsupported osfamily ${::osfamily}"

  $graph_strategy           = 'cgi'
  $html_strategy            = 'cgi'
  $node_definitions         = ''
  $collect_nodes            = 'enabled'
  $dbdir                    = undef
  $htmldir                  = undef
  $logdir                   = undef
  $rundir                   = undef
  $tls                      = 'disabled'
  $tls_certificate          = undef
  $tls_private_key          = undef
  $tls_verify_certificate   = 'yes'
  $extra_config             = []
  $host_name                = $::fqdn

  case $::osfamily {
    'Archlinux',
    'Debian',
    'RedHat': {
      $config_root = '/etc/munin'
    }
    'Solaris': {
      $config_root = '/opt/local/etc/munin'
    }
    'FreeBSD': {
      $config_root = '/usr/local/etc/munin'
    }
    default: {
      fail($message)
    }
  }
}
