Facter.add(:env) do
  setcode do
    if Facter.value(:hostname) =~ /dev/
      'dev'
    elsif Facter.value(:hostname) =~ /6dg/
      '6dg'
    elsif Facter.value(:hostname) =~ /bm/
      'bm'
    else
      'other'
    end
  end
end
