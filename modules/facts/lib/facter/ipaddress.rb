require 'facter'
require 'facter/core/execution'


if File.exist? '/sbin/ip'
  interfaces = Facter::Core::Execution.exec('/sbin/ip route show')
  default_interface = nil
  ipaddress = nil

  if interfaces
    interfaces.each do |inf|
      if inf.match(/^default/)
        default_interface = inf.split()[-1]
      end
    end
  end

  if default_interface
    lines = Facter::Core::Execution.exec("/sbin/ip addr show dev #{default_interface}")
    lines.each do |line|
      line.strip!

      if line.match(/^inet .*#{default_interface}/)
        ipaddress = line.split()[1].split('/')[0]
      end
    end
  end

  Facter.add("default_interface") do
    setcode do
      default_interface
    end
  end

  Facter.add("default_ipaddress") do
    setcode do
      ipaddress
    end
  end
end
