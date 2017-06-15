Facter.add(:env) do
  setcode do
    if Facter.value(:hostname) =~ /dev$/
      'dev'
    elsif Facter.value(:hostname) =~ /debian$/
      'dev'
    else
      'production'
    end
  end
end
