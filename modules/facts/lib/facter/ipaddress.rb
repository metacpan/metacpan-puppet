begin
    # facter version 2 needs these loads
    require 'facter'
    require 'facter/core/execution'
rescue LoadError => e
    # No big defal, facter version 3 autloads these things differently
end


if File.exist? '/sbin/ip'
  interfaces = Facter::Core::Execution.exec('/sbin/ip route show')
  default_interface = nil
  ipaddress = nil

  if interfaces
      interfaces.split(/\n+/).each do |inf|
      if inf.match(/^default/)
        default_interface = inf.match(/dev (\w+)/).captures[0]
      end
    end
  end

  if default_interface
    lines = Facter::Core::Execution.exec("/sbin/ip addr show dev #{default_interface}")
    lines.split(/\n+/).each do |line|
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
