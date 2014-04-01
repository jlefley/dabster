require 'json'
require 'sequel'
require 'htmlentities'
require 'similar_text'
require 'fuzzy_match'

require 'dabster/version'
require 'dabster/sequel'
require 'dabster/whatcd'

module Dabster
  class Error < StandardError; end

  def self.library_database
    '/data/multimedia/musiclibrary.db'
  end

  def self.database
    #'/home/jlefley/development/music/dabster/db/development.sqlite3'
    '/home/jlefley/development/music/dabster/db/dabster.sqlite3'
  end

  def self.connect_library_database
    Sequel::Model.db.run("ATTACH DATABASE '#{Dabster.library_database}' AS libdb")
  end

  def self.log
    '/data/multimedia/dabster.log'
  end
end

if defined?(Rails)
  require 'dabster/engine'
else
  require 'ruby-progressbar'
  require 'thor'
  require 'dabster/cli'

  Sequel.sqlite(Dabster.database)
  Dabster.connect_library_database
  
  %w(whatcd services logic models scrapers).each do |dir|
    Dir["#{Dabster.root}/dabster/#{dir}/**/*.rb"].each { |f| require(f) }
  end
end
