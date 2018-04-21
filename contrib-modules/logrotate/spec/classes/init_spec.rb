require 'spec_helper'

describe 'logrotate' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'logrotate class without any parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('logrotate') }
          %w[install config params rules].each do |classs|
            it { is_expected.to contain_class("logrotate::#{classs}") }
          end

          it do
            is_expected.to contain_package('logrotate').with_ensure('present')

            #    is_expected.to contain_file('/etc/logrotate.conf').with({
            #      'ensure'  => 'file',
            #      'owner'   => 'root',
            #      'group'   => 'root',
            #      'mode'    => '0444',
            #      'content' => 'template(\'logrotate/etc/logrotate.conf.erb\')',
            #      'source'  => 'puppet:///modules/logrotate/etc/logrotate.conf',
            #      'require' => 'Package[logrotate]',
            #    })

            is_expected.to contain_file('/etc/logrotate.d').with('ensure' => 'directory',
                                                                 'owner'   => 'root',
                                                                 'group'   => 'root',
                                                                 'mode'    => '0755')

            is_expected.to contain_file('/etc/cron.daily/logrotate').with('ensure' => 'present',
                                                                          'owner'   => 'root',
                                                                          'group'   => 'root',
                                                                          'mode'    => '0555')

            is_expected.to contain_class('logrotate::defaults')
          end
        end

        context 'logrotate class with manage_package set to to false' do
          let(:params) { { manage_package: false } }

          it do
            is_expected.not_to contain_package('logrotate')
          end
        end

        context 'logrotate class with purge_configdir set to true' do
          let(:params) { { purge_configdir: true } }

          it do
            is_expected.to contain_file('/etc/logrotate.d').with('ensure'  => 'directory',
                                                                 'owner'   => 'root',
                                                                 'group'   => 'root',
                                                                 'mode'    => '0755',
                                                                 'purge'   => true,
                                                                 'recurse' => true)
          end
        end

        context 'logrotate class with create_base_rules set to to false' do
          let(:params) { { create_base_rules: false } }

          it do
            is_expected.not_to contain_logrotate__rule('btmp')
            is_expected.not_to contain_logrotate__rule('wtmp')
          end
        end
      end
    end
  end
end
