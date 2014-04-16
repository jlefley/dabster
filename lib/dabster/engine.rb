require 'sequel-rails'
require 'will_paginate'
require 'will_paginate/sequel'

module Dabster
  class Engine < ::Rails::Engine
    isolate_namespace Dabster
    
    # Dump schema in sql
    config.sequel.schema_format = :sql

    # Add lib to autoload path
    config.autoload_paths << File.join(config.root, 'lib')
    
    initializer 'dabster.initialize', after: 'sequel.configuration' do |app|
      Dabster.initialize
    end

    initializer 'dabster.check_db', before: 'sequel.connect' do |app|
      app_db_path = File.expand_path(app.config.database_configuration[Rails.env].fetch('database'), app.root)
      if app_db_path != Dabster.config.database
        raise(Dabster::Error,
          "Rails database config does not match config.yml, set database in db/database.yml to #{Dabster.config.database}")
      end
    end

    initializer 'dabster.initialize_libdb', after: 'sequel.connect' do |app|
      Dabster.connect_libdb
    end

    initializer 'dabster.append_migrations' do |app|
      config.paths['db/migrate'].expanded.each do |expanded_path|
        #app.config.paths['db/migrate'] << expanded_path
      end
    end
  end
end
