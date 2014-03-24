require 'sequel'

require 'dabster/version'
require 'dabster/sequel'
require 'dabster/what_cd'

module Dabster
  def self.root
    @root = File.expand_path('..', __FILE__)
  end

  def self.library_database
    '/data/multimedia/musiclibrary.db'
  end

  def self.database
    @database = File.join(File.expand_path('../../../..', __FILE__), 'db', 'dabster.sqlite3')
  end

  def self.connect_library_database
    Sequel::Model.db.run("ATTACH DATABASE '#{Dabster.library_database}' AS libdb")
  end
end

if defined?(Rails)
  require 'dabster/railtie'
else
  Sequel.sqlite(Dabster.database)
  Dabster.connect_library_database
  %w(what_cd services logic models scrapers).each do |dir|
    Dir["#{Dabster.root}/dabster/#{dir}/**/*.rb"].each { |f| require(f) }
  end
end

