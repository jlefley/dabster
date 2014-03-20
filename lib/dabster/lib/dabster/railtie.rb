module Dabster
  class Railtie < Rails::Railtie
    initializer 'dabster.autoload', before: :set_autoload_paths do |app|
      app.config.autoload_paths += Dir["#{Dabster.root}/dabster/**"]
    end
    initializer 'dabster.sequel', after: 'sequel.connect' do
      require 'dabster/sequel'
    end
  end
end
