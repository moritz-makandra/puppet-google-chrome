# == Class: google_chrome
#
# Installs the Google Chrome web browser.
#
# === Parameters
#
# [*ensure*]
#   Whether the package should be installed or removed. Valid values are 'installed' and 'absent'.
#   Default: 'installed'
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
# === Examples
#
#  include 'google_chrome'
#
#  class { google_chrome:
#    ensure                 => 'installed',
#    version                => 'beta',
#    package_name           => 'google-chrome',
#    repo_gpg_key           => 'https://dl.google.com/linux/linux_signing_key.pub',
#    repo_gpg_key_id        => '4CCA1EAF950CEE4AB83976DCA040830F7FAC5991',
#    repo_gpg_key_options   => 'http-proxy="http://proxyuser:proxypass@example.org:3128"',
#    repo_name              => 'google-chrome',
#    defaults_file          => '/etc/default/google-chrome',
#    defaults_proxy_pac_url => 'http://foo/bar/proxy.pac',
#    repo_base_url          => 'https://dl.google.com/linux/chrome/rpm/stable/x86_64'
#  }
#
# === Copyright
#
# Copyright 2014 James Netherton
#
class google_chrome (
  String $ensure                                                            = $google_chrome::params::ensure,
  Enum['stable','unstable','beta'] $version                                 = $google_chrome::params::version,
  String $package_name                                                      = $google_chrome::params::package_name,
  Stdlib::Httpsurl $repo_gpg_key                                            = $google_chrome::params::repo_gpg_key,
  String $repo_gpg_key_id                                                   = $google_chrome::params::repo_gpg_key_id,
  Optional[String] $repo_gpg_key_options                                    = $google_chrome::params::repo_gpg_key_options,
  String $repo_name                                                         = $google_chrome::params::repo_name,
  Stdlib::Absolutepath $defaults_file                                       = $google_chrome::params::defaults_file,
  Variant[Stdlib::Httpsurl, Stdlib::Httpurl, Undef] $defaults_proxy_pac_url = $google_chrome::params::defaults_proxy_pac_url,
  String $repo_base_url                                                     = $google_chrome::params::repo_base_url
) inherits google_chrome::params {
  include google_chrome::config
  include google_chrome::install
}
