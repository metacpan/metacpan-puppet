Facter.add(:datacenter) do
  setcode do
    case Facter.value(:ipaddress)
    when /^5\.153\.225\./
      'bytemark-YO26-york'
    when /^46\.43\.35\./
      # This was the old IP address for BM
      'bytemark-YO26-york'
    when /^50\.28\.18\./
      'liquidweb'
    else
      'development'
    end
  end
end
