# Workaround for https://tickets.puppetlabs.com/browse/MODULES-428
# See http://hadooppowered.com/2014/05/12/setup-a-puppetmaster-with-puppetdb-and-puppetboard/
#
Facter.add('vcsrepo') do
  setcode do
    "dummy"
  end
end
