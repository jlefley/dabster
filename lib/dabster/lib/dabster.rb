require 'sequel'

require 'dabster/version'

module Dabster
  def self.root
    @root = File.expand_path('..', __FILE__)
  end

  def self.library_database
    '/home/jlefley/development/music/dabster/musiclibrary.db'
  end

  def self.database
    @database = File.join(File.expand_path('../../../..', __FILE__), 'db', 'development.sqlite3')
  end
end

if defined?(Rails)
  require 'dabster/railtie'
else
  Sequel.sqlite(Dabster.database)
  require 'dabster/sequel'
  %w(what services logic models scrapers).each do |dir|
    Dir["#{Dabster.root}/dabster/#{dir}/**/*.rb"].each { |f| require(f) }
  end
end

Sequel::Model.db.run("ATTACH DATABASE '#{Dabster.library_database}' AS libdb")
