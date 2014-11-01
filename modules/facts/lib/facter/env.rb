Facter.add(:env) do
  setcode do
    if Facter.value(:hostname) =~ /dev$/
      'dev'
    else
      'production'
    end
  end
end
