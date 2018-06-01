require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :operatingsystem => 'Debian',
    :osfamily        => 'Debian',
    :fqdn            => 'testnode.example.com',
  }
end


shared_context :unsupported do
  let(:facts) { { :osfamily => 'Unsupported', } }
end

shared_context :Debian do
end

shared_context :Ubuntu do
  let(:facts) { { :operatingsystem => 'Ubuntu', } }
end

shared_context :CentOS do
  let(:facts) { { :operatingsystem => 'CentOS', :osfamily => 'RedHat', } }
end

shared_context :RedHat do
  let(:facts) { { :osfamily => 'RedHat', } }
end

shared_context :SmartOS do
  let(:facts) { { :operatingsystem => 'SmartOS', :osfamily => 'Solaris', } }
end

