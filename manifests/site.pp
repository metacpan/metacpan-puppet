# Default file attributes - this is done as a security precaution

File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}

firewall { "000 accept related established rules":
  ensure  => present,
  proto   => 'all',
  state   => ['RELATED', 'ESTABLISHED'],
  action  => 'accept',
}
->
firewall { "001 accept all icmp":
  alias   => 'icmp',
  ensure  => present,
  proto   => 'icmp',
  action  => 'accept',
}
->
firewall { "002 accept all to lo interface":
  alias   => 'localhost',
  ensure  => present,
  proto   => 'all',
  iniface => 'lo',
  action  => 'accept',
}
->
firewall { "010 allow ssh access":
  ensure  => present,
  dport   => [ 22 ],
  proto   => tcp,
  action  => 'accept',
  source  => '0.0.0.0/0', # anywhere
}
->
firewall { "999 drop all":
  proto   => 'all',
  action  => 'drop',
  before  => undef,
}

hiera_include('classes')
