# == Class: google_chrome::install
#config
# Installs the Google Chrome web browser.
#
# === Parameters
#
# [*package_name*]
#   The name of the package to install. Default: 'google-chrome-stable'
#
# [*version*]
#   Chrome version to install. Can be one of 'stable' (the default), 'unstable' or 'beta'.
#   Default: 'stable'
#
# [*repo_gpg_key*]
#   The URL of the GPG key used to sign the repository.
#   Default: 'https://dl-ssl.google.com/linux/linux_signing_key.pub'
#
# [*repo_gpg_key_id*]
#   The ID of the GPG key used to sign the repository.
#   Default: '4CCA1EAF950CEE4AB83976DCA040830F7FAC5991'
#
# [*repo_gpg_key_options*]
#   Additional options to pass to the GPG command when importing the key.
#   Default: undef
#
# [*repo_name*]
#   The name of the repository to create.
#   Default: 'google-chrome'
#
# [*defaults_file*]
#   The path to the defaults file that will be created.
#   Default: '/etc/default/google-chrome'
#
# [*defaults_proxy_pac_url*]
#   The URL of the proxy.pac file to use for proxy configuration.
#   Default: undef
#
# [*repo_base_url*]
#   The base URL of the repository.
#   Default: 'https://dl.google.com/linux/chrome/rpm/stable/x86_64'
#
class google_chrome::config (
  Stdlib::Absolutepath $defaults_file    = $google_chrome::params::defaults_file,
  String $repo_name                      = $google_chrome::params::repo_name,
  String $repo_base_url                  = $google_chrome::params::repo_base_url,
  Stdlib::Httpsurl $repo_gpg_key         = $google_chrome::params::repo_gpg_key,
  String $package_name                   = $google_chrome::params::package_name,
  String $version                        = $google_chrome::params::version,
  String $repo_gpg_key_id                = $google_chrome::params::repo_gpg_key_id,
  Optional[String] $repo_gpg_key_options = $google_chrome::params::repo_gpg_key_options,
  Variant[
    Stdlib::Httpsurl, Stdlib::Httpurl, Undef
  ] $defaults_proxy_pac_url              = $google_chrome::params::defaults_proxy_pac_url,
) {
  file { $defaults_file:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('google_chrome/defaults-google-chrome.epp',
      {
        proxy_pac_url => $defaults_proxy_pac_url,
      }
    ),
  }

  case $facts['os']['family'] {
    'RedHat': {
      yumrepo { $repo_name:
        name     => $repo_name,
        descr    => $repo_name,
        enabled  => 1,
        gpgcheck => 1,
        baseurl  => $repo_base_url,
        gpgkey   => $repo_gpg_key,
        before   => Package["${package_name}-${version}"],
      }
    }
    'Debian': {
      Exec['apt_update'] -> Package["${package_name}-${version}"]

      apt::source { $repo_name:
        location     => $repo_base_url,
        release      => 'stable',
        repos        => 'main',
        architecture => $facts['os']['architecture'],
        key          => {
          name    => 'google_chrome.asc',
          source  => $repo_gpg_key,
          options => $repo_gpg_key_options,
        },
        include      => {
          'src' => false,
        },
      }
    }
    'Suse': {
      zypprepo { $repo_name:
        name     => $repo_name,
        baseurl  => $repo_base_url,
        enabled  => 1,
        gpgcheck => 0,
        type     => 'rpm-md',
        before   => Package["${package_name}-${version}"],
      }
    }
    default: {
      fail("Unsupported operating system family ${facts['os']['family']}")
    }
  }
}
