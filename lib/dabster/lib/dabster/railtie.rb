module Dabster
  class Railtie < Rails::Railtie
    initializer 'dabster.autoload', before: :set_autoload_paths do |app|
      dir = File.join(Dabster.root, 'dabster')
      app.config.autoload_paths += %w(models logic scrapers services).map { |d| File.join(dir, d) }
      app.config.autoload_paths << dir
    end
    initializer 'dabster.sequel', after: 'sequel.connect' do
      Dabster.connect_library_database
    end
  end
end
