require 'puppet/provider/file_concat'

Puppet::Type.type(:file_concat).provide(:windows, :parent => Puppet::Type.type(:file).provider(:windows)) do
  confine :feature => :windows
  defaultfor :feature => :windows

  include Puppet::Provider::File_concat
end
