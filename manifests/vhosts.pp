# == Define: certs::vhosts
#
# SSL Certificate File Management
#
# Intended to be used in conjunction with puppetlabs/apache's apache::vhost
# definitions, to provide the ssl_cert and ssl_key files.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  Without Hiera:
#
#    $cname = www.example.com
#    certs::vhosts{ $cname:
#      source_path => 'puppet:///site_certificates/',
#    }
#
#  With Hiera:
#
#    server.yaml
#    ---
#    certs::vhosts::source_path: 'puppet:///site_certificates/'
#    certsvhosts:
#      'www.example.com': {}
#
#    manifest.pp
#    certsvhosts = hiera_hash('certsvhosts')
#    create_resources(certs::vhosts, certsvhosts)
#    Certs::vhosts<| |> -> Apache::vhosts<| |>
#
# === Authors
#
# Rob Nelson <rnelson0@gmail.com>
#
# === Copyright
#
# Copyright 2014 Rob Nelson
#
define certs::vhost (
  $path        = '/etc/ssl/certs',
  $source_path = undef,
) {
  if ($name == undef) {
    fail('You must provide a cname value for the vhost to certs::vhost.')
  }
  if (source_module = undef) {
    fail('You must provide a source_path for the SSL files to certs::vhost.')
  }

  $crt = "${name}.crt"
  $key = "${name}.key"
 
  file { $crt:
    ensure => file,
    path   => "${path}/${crt}",
    source => "${source_path}/${crt}",
  } ->
  file { $key:
    ensure => file,
    path   => "${path}/${key}",
    source => "${source_path}/${key}",
  }
}
