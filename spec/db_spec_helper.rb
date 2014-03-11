require 'sequel'

Sequel.connect(YAML.load_file(File.join(File.expand_path('../../config', __FILE__), 'database.yml'))['test'])

require File.join(File.expand_path('../../config/initializers', __FILE__), 'sequel.rb')

dir = File.expand_path('../..', __FILE__)
Dir[File.join(dir, 'app', 'models', '*.rb')].each { |f| require f }

RSpec.configure do |config|

  config.around :each do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
  
  config.order = 'random'

end
