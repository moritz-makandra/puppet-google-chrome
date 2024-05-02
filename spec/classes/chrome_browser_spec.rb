require 'spec_helper'

describe 'google_chrome' do
  context 'with Debian osfamily' do
    let :facts do
      {
        os: { family => 'Debian', name => 'Debian', release => { major => '9', full => '0' } },
        osfamily: 'Debian',
        lsbdistid: 'Debian',
        puppetversion: Puppet.version,
      }
    end

    it do
      is_expected.to contain_class('google_chrome::config')
      is_expected.to contain_class('google_chrome::install')
      is_expected.to contain_file('/etc/default/google-chrome').with(
        ensure: 'present',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\n",
      )
      is_expected.to contain_apt__source('google-chrome').with(
        location: '[arch=amd64] https://dl.google.com/linux/chrome/deb/',
        release: 'stable',
        key: {
          'id'      => '4CCA1EAF950CEE4AB83976DCA040830F7FAC5991',
          'source'  => 'https://dl.google.com/linux/linux_signing_key.pub',
          'options' => :undef,
        },
        repos: 'main',
        include: {
          'src' => false
        },
      )
      is_expected.to contain_package('google-chrome-stable').with(
        ensure: 'installed',
      )
    end
  end

  context 'does not support RHEL 6' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemmajrelease: 6,
      }
    end

    it 'fails' do
      expect { is_expected.to compile }.to raise_error(%r{Operating system not supported})
    end
  end

  context 'with RedHat osfamily' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'Fedora',
        lsbdistid: 'Fedora',
        operatingsystemmajrelease: 24,
      }
    end

    it do
      is_expected.to contain_class('google_chrome::config')
      is_expected.to contain_class('google_chrome::install')
      is_expected.to contain_file('/etc/default/google-chrome').with(
        ensure: 'present',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\n",
      )
      is_expected.to contain_yumrepo('google-chrome').with(
        name: 'google-chrome',
        descr: 'google-chrome',
        enabled: 1,
        gpgcheck: 1,
        baseurl: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64',
        gpgkey: 'https://dl.google.com/linux/linux_signing_key.pub',
      )
      is_expected.to contain_package('google-chrome-stable').with(
        ensure: 'installed',
      )
    end
  end

  context 'with Suse osfamily' do
    let :facts do
      {
        osfamily: 'Suse',
        operatingsystem: 'OpenSuse',
        lsbdistid: 'OpenSuse',
      }
    end

    it do
      is_expected.to contain_class('google_chrome::config')
      is_expected.to contain_class('google_chrome::install')
      is_expected.to contain_file('/etc/default/google-chrome').with(
        ensure: 'present',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\n",
      )
      is_expected.to contain_zypprepo('google-chrome').with(
        name: 'google-chrome',
        baseurl: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64',
        enabled: 1,
        gpgcheck: 0,
        type: 'rpm-md',
      )
      is_expected.to contain_package('google-chrome-stable').with(
        ensure: 'installed',
      )
    end
  end

  context 'with Debain osfamily all parameters overridden' do
    let :facts do
      {
        os: { family: 'Debian', name: 'Debian', release: { major: '9', full: '0' } },
        osfamily: 'Debian',
        lsbdistid: 'Debian',
        puppetversion: Puppet.version,
      }
    end

    let :params do
      {
        version: 'unstable',
        package_name: 'fake-google-chrome',
        repo_gpg_key: 'http://test.org/gpg.key',
        repo_gpg_key_id: '0AAA0AAF000AAA0AA00000AAA000000A0AAA0000',
        repo_gpg_key_options: 'http-proxy="http://proxyuser:proxypass@example.org:3128"',
        repo_name: 'fake-google-chrome',
        defaults_file: '/etc/default/fake-google-chrome',
        defaults_proxy_pac_url: 'http://test.org/proxy.pac'
      }
    end

    it do
      is_expected.to contain_class('google_chrome::config')
      is_expected.to contain_class('google_chrome::install')
      is_expected.to contain_file('/etc/default/fake-google-chrome').with(
        ensure: 'present',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\nproxy-pac-url=\"http://test.org/proxy.pac\"\n",
      )
      is_expected.to contain_apt__source('fake-google-chrome').with(
        location: '[arch=amd64] https://dl.google.com/linux/chrome/deb/',
        release: 'stable',
        key: {
          'id'      => '0AAA0AAF000AAA0AA00000AAA000000A0AAA0000',
          'source'  => 'http://test.org/gpg.key',
          'options' => 'http-proxy="http://proxyuser:proxypass@example.org:3128"',
        },
        repos: 'main',
        include: {
          'src' => false
        },
      )
      is_expected.to contain_package('fake-google-chrome-unstable').with(
        ensure: 'installed',
      )
    end
  end

  context 'with RedHat osfamily all parameters overridden' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystem: 'Fedora',
        lsbdistid: 'Fedora',
        operatingsystemmajrelease: 24,
      }
    end

    let :params do
      {
        version: 'unstable',
        package_name: 'fake-google-chrome',
        repo_gpg_key: 'http://test.org/gpg.key',
        repo_name: 'fake-google-chrome',
        defaults_file: '/etc/default/fake-google-chrome',
        defaults_proxy_pac_url: 'http://test.org/proxy.pac'
      }
    end

    it do
      is_expected.to contain_class('google_chrome::config')
      is_expected.to contain_class('google_chrome::install')
      is_expected.to contain_file('/etc/default/fake-google-chrome').with(
        ensure: 'present',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\nproxy-pac-url=\"http://test.org/proxy.pac\"\n",
      )
      is_expected.to contain_yumrepo('fake-google-chrome').with(
        name: 'fake-google-chrome',
        descr: 'fake-google-chrome',
        enabled: 1,
        gpgcheck: 1,
        baseurl: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64',
        gpgkey: 'http://test.org/gpg.key',
      )
      is_expected.to contain_package('fake-google-chrome-unstable').with(
        ensure: 'installed',
      )
    end
  end

  context 'with Suse osfamily all parameters overridden' do
    let :facts do
      {
        osfamily: 'Suse',
        operatingsystem: 'OpenSuse',
        lsbdistid: 'OpenSuse',
      }
    end

    let :params do
      {
        version: 'unstable',
        package_name: 'fake-google-chrome',
        repo_gpg_key: 'http://test.org/gpg.key',
        repo_name: 'fake-google-chrome',
        defaults_file: '/etc/default/fake-google-chrome',
        defaults_proxy_pac_url: 'http://test.org/proxy.pac'
      }
    end

    it do
      is_expected.to contain_class('google_chrome::config')
      is_expected.to contain_class('google_chrome::install')
      is_expected.to contain_file('/etc/default/fake-google-chrome').with(
        ensure: 'present',
        owner: 'root',
        group: 'root',
        mode: '0644',
        content: "repo_add_once=\"false\"\nrepo_reenable_on_distupgrade=\"true\"\nproxy-pac-url=\"http://test.org/proxy.pac\"\n",
      )
      is_expected.to contain_zypprepo('fake-google-chrome').with(
        name: 'fake-google-chrome',
        baseurl: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64',
        enabled: 1,
        gpgcheck: 0,
        type: 'rpm-md',
      )
      is_expected.to contain_package('fake-google-chrome-unstable').with(
        ensure: 'installed',
      )
    end
  end

  context 'with invalid osfamily' do
    let :facts do
      {
        osfamily: 'Darwin',
      }
    end

    it 'fails' do
      expect { is_expected.to compile }.to raise_error(%r{Unsupported operating system family})
    end
  end

  context 'with invalid chrome version' do
    let :facts do
      {
        osfamily: 'Debian',
      }
    end

    let :params do
      {
        version: 'test-version',
      }
    end

    it 'fails' do
      expect { is_expected.to compile }.to raise_error(%r{Enum})
    end
  end
end
