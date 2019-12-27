require 'spec_helper'
describe 'certs' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('certs') }
  end
end
