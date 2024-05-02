# == Class: google_chrome::install
#
# Installs the Google Chrome web browser.
#
# === Parameters
#
# [*package_name*]
#   The name of the package to install.
#
# [*version*]
#   The version of the package to install.
#
# [*ensure*]
#   The ensure value for the package resource.
#
class google_chrome::install (
  String $package_name,
  String $version,
  String $ensure,
) {
  package { "${package_name}-${version}":
    ensure => $ensure,
  }
}
