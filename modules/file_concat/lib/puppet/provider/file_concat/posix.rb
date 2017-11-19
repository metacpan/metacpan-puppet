require 'puppet/provider/file_concat'

Puppet::Type.type(:file_concat).provide(:posix, :parent => Puppet::Type.type(:file).provider(:posix)) do
  confine :feature => :posix
  defaultfor :feature => :posix

  include Puppet::Provider::File_concat
end
