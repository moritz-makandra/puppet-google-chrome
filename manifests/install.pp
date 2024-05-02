# == Class: google_chrome::install
#
# Installs the Google Chrome web browser.
#
# === Parameters
#
# [*ensure*]
#   The ensure value for the package resource.
#
# [*package_name*]
#   The name of the package to install.
#
# [*version*]
#   The version of the package to install.
#
class google_chrome::install (
  String $ensure       = $google_chrome::params::ensure,
  String $package_name = $google_chrome::params::package_name,
  String $version      = $google_chrome::params::version,
) {
  package { "${package_name}-${version}":
    ensure => $ensure,
  }
}
