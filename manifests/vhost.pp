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
# @param source_name
#  Name of the file to use if different than the title of the resource
#  Default: '$name'
# @param vault
#  Use vault_lookup to query vault service for crt/key pair
#  Default: 'undef'
define certs::vhost (
  $source_name    = $name,
  $source_path    = undef,
  $target_path    = '/etc/ssl/certs',
  $service        = 'httpd',
  $vault          = undef,
  $notify_service = true,
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

  $crt_name = "${name}.crt"
  $key_name = "${name}.key"

  if $vault {
    $vault_ssl_hash = vault_lookup("${source_path}/${source_name}")

    file { $crt_name:
      ensure  => file,
      path    => "${target_path}/${crt_name}",
      content => inline_epp('<%= $data %>', {'data' => $vault_ssl_hash['crt']}),
    }
    -> file { $key_name:
      ensure  => file,
      path    => "${target_path}/${key_name}",
      content => inline_epp('<%= $data %>', {'data' => $vault_ssl_hash['key']}),
    }
  }
  else {
    file { $crt_name:
      ensure => file,
      path   => "${target_path}/${crt_name}",
      source => "${source_path}/${source_name}.crt",
    }
    -> file { $key_name:
      ensure => file,
      path   => "${target_path}/${key_name}",
      source => "${source_path}/${source_name}.key",
    }
  }
  if $notify_service { Certs::Vhost[$title] ~> Service[$service] }
}
