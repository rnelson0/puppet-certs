require 'spec_helper'

describe 'certs::vhost' do
  let(:title) { 'www.example.com' }
  let(:params) { {
    :source_path => 'puppet:///othermodule/',
  } }

  it do
    should contain_file('www.example.com.crt').with({
      :path => '/etc/ssl/certs/www.example.com.crt',
    })
  end
  it do
    should contain_file('www.example.com.key').with({
      :path => '/etc/ssl/certs/www.example.com.key',
    })
  end

  context 'with target_path => /etc/httpd/ssl.d' do
    let(:params) { {
      :source_path => 'puppet:///othermodule/',
      :target_path => '/etc/httpd/ssl.d',
    } }

    it do
      should contain_file('www.example.com.crt').with({
        :path => '/etc/httpd/ssl.d/www.example.com.crt',
      })
    end
    it do
      should contain_file('www.example.com.key').with({
        :path => '/etc/httpd/ssl.d/www.example.com.key',
      })
    end
  end
end
