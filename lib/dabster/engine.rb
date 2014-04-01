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

    initializer 'dabster.check_db', before: 'sequel.configuration' do |app|
      if (path = app.config.database_configuration[Rails.env].fetch('database')) != Dabster.config[:database]
        raise(Dabster::Error,
          "Rails database config does not match config.yml, set database in db/database.yml to #{Dabster.config[:database]}")
      end
    end
  end
end
