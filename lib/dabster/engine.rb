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
  end
end
