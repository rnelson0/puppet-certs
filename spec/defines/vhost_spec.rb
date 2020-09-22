require 'spec_helper'

describe 'certs::vhost' do
  let(:pre_condition) do
    "service {'httpd': ensure => running}"
  end

  let(:title) { 'www.example.com' }

  context 'with source_path => puppet:///othermodule' do
    let(:params) do
      {
        source_path: 'puppet:///othermodule',
      }
    end

    it {
      is_expected.to contain_file('www.example.com.crt').with(path: '/etc/ssl/certs/www.example.com.crt',
                                                              source: 'puppet:///othermodule/www.example.com.crt',
                                                              notify: 'Service[httpd]')
    }
    it {
      is_expected.to contain_file('www.example.com.key').with(path: '/etc/ssl/certs/www.example.com.key',
                                                              source: 'puppet:///othermodule/www.example.com.key',
                                                              notify: 'Service[httpd]')
    }
  end

  context 'with target_path => /etc/httpd/ssl.d' do
    let(:params) do
      {
        source_path: 'puppet:///othermodule',
        target_path: '/etc/httpd/ssl.d',
      }
    end

    it {
      is_expected.to contain_file('www.example.com.crt').with(path: '/etc/httpd/ssl.d/www.example.com.crt',
                                                              source: 'puppet:///othermodule/www.example.com.crt')
    }
    it {
      is_expected.to contain_file('www.example.com.key').with(path: '/etc/httpd/ssl.d/www.example.com.key',
                                                              source: 'puppet:///othermodule/www.example.com.key')
    }
  end

  context 'with service => nginx' do
    let(:pre_condition) do
      "service {'nginx': ensure => running}"
    end

    let(:params) do
      {
        source_path: 'puppet:///othermodule',
        service: 'nginx',
      }
    end

    it {
      is_expected.to contain_file('www.example.com.crt').with(notify: 'Service[nginx]')
    }
  end

  context 'with vault => true' do
    let(:params) do
      {
        source_path: '/v1/api/kv/certs/puppet/',
        vault: true,
      }
    end

    before :each do
      Puppet::Parser::Functions.newfunction(:vault_lookup, type: :rvalue) do |args| # rubocop:disable Lint/UnusedBlockArgument
        {
          'crt' => "-----BEGIN CERTIFICATE-----\nTEST\n-----END CERTIFICATE-----",
          'key' => "-----BEGIN PRIVATE KEY-----\nTEST\n-----END PRIVATE KEY-----",
        }
      end
    end

    it {
      is_expected.to contain_file('www.example.com.crt').with(path: '/etc/ssl/certs/www.example.com.crt',
                                                              content: %r{^-----BEGIN CERTIFICATE-----\n([a-zA-Z0-9]\n?)+\n-----END CERTIFICATE-----}m,
                                                              notify: 'Service[httpd]')
    }
    it {
      is_expected.to contain_file('www.example.com.key').with(path: '/etc/ssl/certs/www.example.com.key',
                                                              content: %r{^-----BEGIN PRIVATE KEY-----\n([a-zA-Z0-9]\n?)+\n-----END PRIVATE KEY-----}m,
                                                              notify: 'Service[httpd]')
    }
  end
end
