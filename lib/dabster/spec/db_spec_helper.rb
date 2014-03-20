#Sequel.extension :migration
#Sequel.connect(YAML.load_file(File.join(File.expand_path('../../config', __FILE__), 'database.yml'))['test'])
#load File.join(dir, 'db', 'schema.rb')
#Sequel::Migration.descendants.each { |m| m.apply(Sequel::Model.db, :up) }

dir = File.expand_path('../../lib', __FILE__)
$:.push File.join(dir, 'sequel', 'plugins')
$:.push File.join(dir, 'dabster', 'models')
$:.push File.join(dir, 'dabster', 'logic')

require 'sequel'

Sequel.sqlite
require File.join(dir, 'dabster', 'sequel.rb')
Sequel::Model.db.run(File.read(File.join(File.expand_path('../../../../db', __FILE__), 'structure.sql')))

RSpec.configure do |config|

  config.around :each do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
  
  config.order = 'random'

end
