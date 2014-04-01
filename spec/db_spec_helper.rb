#Sequel.extension :migration
#Sequel.connect(YAML.load_file(File.join(File.expand_path('../../config', __FILE__), 'database.yml'))['test'])
#load File.join(dir, 'db', 'schema.rb')
#Sequel::Migration.descendants.each { |m| m.apply(Sequel::Model.db, :up) }

require 'unit_spec_helper'
require 'sequel'

root = File.expand_path('../..', __FILE__)

Sequel.sqlite
require File.join(root, 'lib', 'dabster', 'sequel.rb')
Sequel::Model.db.run(File.read(File.join(root, 'db', 'structure.sql')))
load File.join(root, 'db', 'seeds.rb')

$: << File.join(root, 'app', 'models', 'dabster')

RSpec.configure do |config|

  config.around :each do |example|
    Sequel::Model.db.transaction(rollback: :always) { example.run }
  end
  
  config.order = 'random'

end
