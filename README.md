# certs

[![Build Status](https://travis-ci.org/rnelson0/puppet-certs.png?branch=master)](https://travis-ci.org/rnelson0/puppet-certs)
[![Puppet Forge](http://img.shields.io/puppetforge/v/rnelson0/certs.svg)](https://forge.puppetlabs.com/rnelson0/certs)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/rnelson0/certs.svg)](https://forge.puppetlabs.com/rnelson0/certs)
[![Stories in Ready](https://badge.waffle.io/rnelson0/puppet-certs.svg?label=ready&title=Ready)](http://waffle.io/rnelson0/puppet-modules)
[![Stories In Progress](https://badge.waffle.io/rnelson0/puppet-certs.svg?label=in%20progress&title=In%20Progress)](http://waffle.io/rnelson0/puppet-modules)

#### Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with certs](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with certs](#beginning-with-certs)
4. [Usage - Configuration options and additional functionality](#usage)

## Overview

Provides SSL certificate files required by apache and other webservers via
the certs::vhost define. These files can then be provided to apache::vhost and
other classes that require the files to already exist on a managed node.

## Setup

### Setup Requirements

The certificate files must come from an external store. Recommended stores
are a site-specific (and private!) module containing SSL files or a network-
accessible filesystem, such as NFS, that the managed node can access.

### Beginning with certs

Once a file store is determined, include at least one certs::vhost define
and specify the file store location as the `source_path`. You may optionally
specify a `target_path` if the default location of `/etc/ssl/certs` is not
desired.

## Usage

No trailing slash should be provided to `source_path`.

    certs::vhost { 'www.example.com':
      source_path => 'puppet:///modules/site_certificates',
    }

Creates `/etc/ssl/certs/www.example.com.crt` and
`/etc/ssl/certs/www.example.com.key` based off of
`puppet:///site_certificates/www.example.com.crt` and
`puppet:///site_certificates/www.example.com.key`.

    certs::vhost { 'www.example.com':
      target_path => '/etc/httpd/ssl.d',
      source_path => 'puppet:///modules/site_certificates',
    }

Creates the same crt and key files in `/etc/httpd/ssl.d`.

    Certs::Vhost<| |> -> Apache::Vhost<| |>

If you wish for your certificate and key to go to different paths, you can specify them accordingly.  If one or bothof these values are not passed, `target_path` will be used.

    certs::vhost { 'www.example.com':
      crt_target_path => '/etc/pki/certs',
      key_target_path => '/etc/pki/private',
      source_path => 'puppet:///modules/site_certificates',
    }

When providing the certificate files to the `apache::vhost` or similar classes
it is best to ensure they are properly dependent upon the `certs::vhost`.

To use the vault options, you must have a module that is API compatible with [puppet-vault_lookup](https://forge.puppet.com/puppet/vault_lookup) installed. If you are not using vault, this dependency is optional.  Some types of certificates may have been encoded with base64 for compatibility with Vault, you can specify `base64_vault_crt` to decode this certificate type.

    certs::vhost { 'www.example.com':
      target_path      => '/etc/httpd/ssl.d',
      source_path      => '/v1/kv/puppet/ssl',
      vault            => true,
      base64_vault_crt => true,
    }

You can optionally specify file options such as owner and mode by using the `file_options` variable.

    certs::vhost { 'www.example.com':
      target_path  => '/etc/httpd/ssl.d',
      source_path  => 'puppet:///modules/site_certificates',
      file_options => { owner => 'root',
                        group => 'root',
                        mode  => '0644',}
    }
