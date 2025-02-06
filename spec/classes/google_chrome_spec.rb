require 'spec_helper'

describe 'google_chrome' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it do
        is_expected.to compile.with_all_deps
        is_expected.to contain_class('google_chrome::config')
        is_expected.to contain_class('google_chrome::install')

        is_expected.to contain_file('/etc/default/google-chrome').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          mode: '0644',
          content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\n",
        )


        is_expected.to contain_package('google-chrome-stable').with(
          ensure: 'installed',
        )

        case os
        when /ubuntu/
          is_expected.to contain_apt__source('google-chrome').with(
            location: '[arch=amd64] https://dl.google.com/linux/chrome/deb/',
            release: 'stable',
            key: {
              'id'      => '4CCA1EAF950CEE4AB83976DCA040830F7FAC5991',
              'source'  => 'https://dl.google.com/linux/linux_signing_key.pub',
              'options' => nil,
            },
            repos: 'main',
            include: {
              'src' => false
            },
          )
        when /RedHat/
          is_expected.to contain_yumrepo('google-chrome').with(
            name: 'google-chrome',
            descr: 'google-chrome',
            enabled: 1,
            gpgcheck: 1,
            baseurl: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64',
            gpgkey: 'https://dl.google.com/linux/linux_signing_key.pub',
          )
        when /Suse/
          is_expected.to contain_zypprepo('google-chrome').with(
            name: 'google-chrome',
            baseurl: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64',
            enabled: 1,
            gpgcheck: 0,
            type: 'rpm-md',
          )
        end
      end
    end
  end

  context 'on RHEL 6' do
    let :facts do
      {
        # osfamily: 'RedHat',
        # operatingsystemmajrelease: 6,
        os: {
          release:{
            major: '6'
          },
          family: 'RedHat'
        }
      }
    end

    it 'not supported' do
      is_expected.to raise_error(Puppet::Error, %r{Operating system not supported})
    end
  end

  context 'with invalid osfamily' do
    let :facts do
      {
        os: {
          family: 'Darwin'
        },
      }
    end

    it 'fails' do
      expect { is_expected.to compile }.to raise_error(%r{Unsupported operating system family})
    end
  end
end
