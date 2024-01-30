Facter.add("default_ipaddress") do
  setcode do
    if Facter.value('ipaddress_eth0')
      Facter.value('ipaddress_eth0')
    elsif Facter.value('ipaddress_bond0')
      Facter.value('ipaddress_bond0')
    elsif Facter.value('ipaddress_eth2')
      Facter.value('ipaddress_eth2')
    else
      Facter.value('ipaddress')
    end
  end
end
