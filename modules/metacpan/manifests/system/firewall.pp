define metacpan::system::firewall(
  $ensure = present,
  $order = '300',
  $port,
  $proto = 'tcp',
  $action = 'accept',
  $source = '127.0.0.1',
) {

  firewall { "${order} ${action} ${proto} ${port} ${name}":
      ensure  => $ensure,
      dport   => [ $port ],
      proto   => $proto,
      action  => $action,
      source  => $source, # anywhere
    }

}
