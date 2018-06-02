require 'spec_helper'

describe 'munin::plugin' do

  include_context :Debian
  let(:title) { 'testplugin' }

  context 'with config_label unset, label should be set to title' do
    let(:params) do
      { config: ['env.foo bar'] }
    end

    it do
      should contain_file('/etc/munin/plugin-conf.d/testplugin.conf')
        .with_content(/^\[testplugin\]$/)
    end
  end

  context 'with config_label set, label should be set to config_label' do
    let(:params) do
      { config: ['env.foo bar'],
        config_label: 'foo_' }
    end
    it do
      should contain_file('/etc/munin/plugin-conf.d/testplugin.conf')
        .with_content(/^\[foo_\]$/)
    end
  end

end
