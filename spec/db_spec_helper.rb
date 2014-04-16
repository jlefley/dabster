#Sequel.extension :migration
#Sequel.connect(YAML.load_file(File.join(File.expand_path('../../config', __FILE__), 'database.yml'))['test'])
#load File.join(dir, 'db', 'schema.rb')
#Sequel::Migration.descendants.each { |m| m.apply(Sequel::Model.db, :up) }

require 'sequel'
require 'unit_spec_helper'
require 'sequel_initialization'

root = File.expand_path('../..', __FILE__)

Sequel.sqlite

if !Sequel::Model.db.table_exists?(:groups)
  Sequel::Model.db.run(File.read(File.join(root, 'db', 'structure.sql')))
  load File.join(root, 'db', 'seeds.rb')

  Sequel::Model.db.run(%(ATTACH DATABASE ':memory:' AS libdb))
  Sequel::Model.db.create_table(:libdb__items) { primary_key :id }
end

$: << File.join(root, 'app', 'models', 'dabster')

RSpec.configure do |config|

  config.around :each do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
  
  config.order = 'random'

end
