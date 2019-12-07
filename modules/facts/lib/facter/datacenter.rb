Facter.add(:datacenter) do
  setcode do
    case Facter.value(:hostname)
    when /^bm-mc-/
      'bytemark-YO26-york'
    when /^lw-mc-/
      'liquidweb'
    when /^hc-mc-/
      'hivelocity'
    else
      'development'
    end
  end
end
