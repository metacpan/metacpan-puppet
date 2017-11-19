# Class to export the munin node.
#
# This is separated into its own class to avoid warnings about missing
# storeconfigs.
#
class munin::node::export (
  $address,
  $fqn,
  $masterconfig,
  $mastername,
)
{
  @@munin::master::node_definition{ $fqn:
    address    => $address,
    mastername => $mastername,
    config     => $masterconfig,
    tag        => [ "munin::master::${mastername}" ],
  }
}
