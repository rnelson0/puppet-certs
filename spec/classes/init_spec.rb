require 'spec_helper'
describe 'certs' do
  context 'with defaults for all parameters' do
    it { should contain_class('certs') }
  end
end
