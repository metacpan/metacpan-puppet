Facter.add(:datacenter) do
  setcode do
    case Facter.value(:ipaddress)
    when /^5\.153\.225\./
      # bm-mc-01 and bm-mc-02
      'bytemark-YO26-york'
    when /^46\.43\.35\.68/
      # bm-mc-03
      'bytemark-YO26-york'
    when /^89\.16\.178\.21/
      # bm-mc-04
      'bytemark-YO26-york'
    when /^50\.28\.18\./
      'liquidweb'
    else
      'development'
    end
  end
end
