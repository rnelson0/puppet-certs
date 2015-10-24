require 'spec_helper'

describe 'certs::vhost' do
  let(:title) { 'www.example.com' }
  let(:params) do
    {
      :source_path => 'puppet:///othermodule'
    }
  end

  it { should contain_file('www.example.com.crt').with({
    :path   => '/etc/ssl/certs/www.example.com.crt',
    :source => 'puppet:///othermodule/www.example.com.crt',
    :notify => "Service[httpd]"
  }) }
  it { should contain_file('www.example.com.key').with({
    :path   => '/etc/ssl/certs/www.example.com.key',
    :source => 'puppet:///othermodule/www.example.com.key',
    :notify => "Service[httpd]"
  }) }

  context 'with target_path => /etc/httpd/ssl.d' do
    let(:params) do
      {
        :source_path => 'puppet:///othermodule',
        :target_path => '/etc/httpd/ssl.d'
      }
    end

    it { should contain_file('www.example.com.crt').with({
      :path   => '/etc/httpd/ssl.d/www.example.com.crt',
      :source => 'puppet:///othermodule/www.example.com.crt',
    }) }
    it { should contain_file('www.example.com.key').with({
      :path   => '/etc/httpd/ssl.d/www.example.com.key',
      :source => 'puppet:///othermodule/www.example.com.key',
    }) }
  end

  context 'with service => nginx' do
    let(:params) do
      {
        :source_path => 'puppet:///othermodule',
        :service     => 'nginx'
      }
    end

    it { should contain_file('www.example.com.crt').with({
      :notify => 'Service[nginx]'
    }) }
  end
end
