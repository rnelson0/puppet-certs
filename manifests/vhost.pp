# @summary Used in conjunction with puppetlabs/apache's apache::vhost definitions, to provide the related ssl_cert and ssl_key files for a given vhost.
#
# @example
#    Without Hiera:
#
#      $cname = www.example.com
#      certs::vhost{ $cname:
#        source_path => 'puppet:///site_certificates',
#      }
#
#    With Hiera:
#  
#      server.yaml
#      ---
#      certsvhost:
#        'www.example.com':
#          source_path: 'puppet:///modules/site_certificates/'
#  
#      manifest.pp
#      ---
#      certsvhost = hiera_hash('certsvhost')
#      create_resources(certs::vhost, certsvhost)
#      Certs::Vhost<| |> -> Apache::Vhost<| |>
#
# @param title
#  The title of the resource matches the certificate's name # e.g. 'www.example.com' matches the certificate for the hostname # 'www.example.com'
# @param source_path
#  Required. The location of the certificate files. Typically references a module's files. e.g. 'puppet:///site_certs' will search $modulepath/site_certs/files on the master for the specified files.
# @param target_path
#  Location where the certificate files will be stored on the managed node.
#  Default: '/etc/ssl/certs'
# @param service
#  Name of the web server service to notify when certificates are updated.
#  Default: 'http'
define certs::vhost (
  $source_path = undef,
  $target_path = '/etc/ssl/certs',
  $service     = 'httpd',
) {
  if ($name == undef) {
    fail('You must provide a name value for the vhost to certs::vhost.')
  }
  if ($source_path == undef) {
    fail('You must provide a source_path for the SSL files to certs::vhost.')
  }
  if ($target_path == undef) {
    fail('You must provide a target_ path for the certs to certs::vhost.')
  }

  $crt = "${name}.crt"
  $key = "${name}.key"

  file { $crt:
    ensure => file,
    path   => "${target_path}/${crt}",
    source => "${source_path}/${crt}",
    notify => Service[$service],
  }
  -> file { $key:
    ensure => file,
    path   => "${target_path}/${key}",
    source => "${source_path}/${key}",
    notify => Service[$service],
  }
}
