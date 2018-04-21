require 'spec_helper'

_conf_dir = {}
_conf_dir.default = '/etc/munin'
_conf_dir['Solaris'] = '/opt/local/etc/munin'
_conf_dir['FreeBSD'] = '/usr/local/etc/munin'

_share_dir = {}
_share_dir.default = '/usr/share/munin'
_share_dir['Solaris'] = '/opt/local/share/munin'
_share_dir['FreeBSD'] = '/usr/local/share/munin'

describe 'munin::plugin', :type => 'define' do

  let(:title) { 'testplugin' }

  on_supported_os.each do |os, facts|

    # Avoid testing on distributions similar to RedHat and Debian
    next if /^(ubuntu|centos|scientific|oraclelinux)-/.match(os)

    # No need to test all os versions as long as os version is not
    # used in the params class
    next if /^(debian-[67]|redhat-[56]|freebsd-9)-/.match(os)

    context "on #{os}" do
      let(:facts) do
        facts
      end

      conf_dir = _conf_dir[facts[:osfamily]]
      plugin_share_dir = "#{_share_dir[facts[:osfamily]]}/plugins"

      context 'with no parameters' do
        it do
          expect { should contain_file("#{conf_dir}/plugins/testplugin") }
            .to raise_error("expected that the catalogue would contain File[#{conf_dir}/plugins/testplugin]")
        end
        it do
          should contain_file("#{conf_dir}/plugin-conf.d/testplugin.conf")
                  .with_ensure('absent')
        end
      end

      context 'with ensure=link parameter' do
        let(:params) { { :ensure => 'link' } }
        it do
          should contain_file("#{conf_dir}/plugins/testplugin")
                  .with_ensure('link')
                  .with_target("#{plugin_share_dir}/testplugin")
        end
        it do
          should contain_file("#{conf_dir}/plugin-conf.d/testplugin.conf")
                  .with_ensure('absent')
        end
      end

      context 'with ensure=link and target parameters' do
        let(:title) { 'test_foo' }
        let(:params) do
          { :ensure => 'link',
            :target => 'test_' }
        end
        it do
          should contain_file("#{conf_dir}/plugins/test_foo")
                  .with_ensure('link')
                  .with_target("#{plugin_share_dir}/test_")
        end
        it do
          should contain_file("#{conf_dir}/plugin-conf.d/test_foo.conf")
                  .with_ensure('absent')
        end
      end

      context 'with ensure=present and source parameters' do
        let(:params) do
          { :ensure => 'present',
            :source => 'puppet:///modules/munin/plugins/testplugin' }
        end
        it do
          should contain_file("#{conf_dir}/plugins/testplugin")
                    .with_ensure('present')
                    .with_source('puppet:///modules/munin/plugins/testplugin')
        end
        it do
          should contain_file("#{conf_dir}/plugin-conf.d/testplugin.conf")
                  .with_ensure('absent')
        end
      end

      context 'with ensure=present, source and config parameters' do
        let(:params) do
          { :ensure => 'present',
            :source => 'puppet:///modules/munin/plugins/testplugin',
            :config => [ 'something wonderful' ],
          }
        end
        it do
          should contain_file("#{conf_dir}/plugins/testplugin")
                  .with_ensure('present')
                  .with_source('puppet:///modules/munin/plugins/testplugin')
        end
        it do
          should contain_file("#{conf_dir}/plugin-conf.d/testplugin.conf")
                  .with_ensure('present')
                  .with_content(/something wonderful/)
        end
      end

      context 'only configuration' do
        let(:params) do
          { :config => ['env.rootdn cn=admin,dc=example,dc=org'],
            :config_label => 'slapd_*',
          }
        end
        it do
          should contain_file("#{conf_dir}/plugin-conf.d/testplugin.conf")
                  .with_ensure('present')
                  .with_content(/env.rootdn/)

        end
        it do
          expect { should contain_file("#{conf_dir}/plugins/testplugin") }
            .to raise_error("expected that the catalogue would contain File[#{conf_dir}/plugins/testplugin]")
        end
      end

      context 'with absolute target' do
        let(:params) do
          { ensure: 'link',
            target: '/full/path/to/testplugin' }
        end
        it do
          should contain_file("#{conf_dir}/plugins/testplugin")
                  .with_ensure('link')
                  .with_target('/full/path/to/testplugin')
        end
      end

    end
  end

end
