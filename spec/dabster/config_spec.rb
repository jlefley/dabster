require 'unit_spec_helper'
require 'config'

describe 'configuration' do
  
  let(:config) { Dabster.config }

  context 'when configuration is loaded from file' do
    it 'loads options according to environment' do
      ENV['DABSTER_ENV'] = 'test'
      Dabster.configure(File.join(File.expand_path('../..', __FILE__), 'resources', 'test_config.rb'))

      expect(config.database).to eq('testdb')
    end
  end

end
