require 'yaml'
require 'sequel'

Sequel.extension :migration

Sequel.connect(YAML.load_file(File.join(File.expand_path('../../config', __FILE__), 'database.yml'))['test'])

require File.join(File.expand_path('../../config/initializers', __FILE__), 'sequel.rb')

dir = File.expand_path('../..', __FILE__)
Sequel::Model.db.run(File.read(File.join(dir, 'db', 'structure.sql')))
#load File.join(dir, 'db', 'schema.rb')
#Sequel::Migration.descendants.each { |m| m.apply(Sequel::Model.db, :up) }
$:.push File.join(dir, 'app', 'models')
$:.push File.join(dir, 'lib', 'sequel')
$:.push File.join(dir, 'app', 'logic')

RSpec.configure do |config|

  config.around :each do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
  
  config.order = 'random'

end
