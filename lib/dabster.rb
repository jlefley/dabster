require 'sequel'
require 'fileutils'
require 'dabster/version'
require 'dabster/sequel'
require 'dabster/errors'
require 'dabster/config'

module Dabster
 
  def self.log(level, msg)
    File.open(config.log, 'a') do |file|
      file.puts("[#{level} #{Time.now}]")
      file.puts(msg)
      file.write("\n")
    end
  end

  def self.initialize
    # Create config directory
    FileUtils.mkdir_p("#{Dir.home}/.config/dabster")

    # Load config
    configure("#{root}/config/defaults.rb")
    begin
      configure("#{Dir.home}/.config/dabster/config.rb")
    rescue LoadError
      log(:warning, 'Config file could not be found. Using defaults.')
    end
  end

  def self.connect_libdb
    if File.exists?(config.library_database) || config.library_database == ':memory:'
      Sequel::Model.db.run("ATTACH DATABASE '#{config.library_database}' AS libdb")
    else
      raise(Dabster::Error,
            "library_database (#{config.library_database}) could not be found. "\
            "Set library_database in #{Dir.home}/.config/dabster/config.rb to the path "\
            "to your beets database file or to :memory:.")
    end
  end

  def self.initialize_db
    # Load structure if not already
    if !Sequel::Model.db.table_exists?(:groups)
      Sequel::Model.db.run(File.read(File.join(root, 'db', 'structure.sql')))
    end
    
    # Load seeds if not already
    if Sequel::Model.db[:whatcd_release_types].count == 0
      load(File.join(root, 'db', 'seeds.rb'))
    end
  end

  def self.root
    @root ||= File.expand_path('../..', __FILE__)
  end
  
end

if defined?(Rails)
  ENV['DABSTER_ENV'] = Rails.env
  require 'dabster/engine'
else
  require 'dabster/cli'
  
  Dabster.initialize
  Sequel.sqlite(Dabster.config.database)
  Dabster.connect_libdb 
  Dabster.initialize_db
  
  %w(whatcd services logic scrapers).each do |dir|
    Dir["#{Dabster.root}/lib/dabster/#{dir}/**/*.rb"].each { |f| require(f) }
  end

  Dir["#{Dabster.root}/app/models/dabster/**/*.rb"].each { |f| require(f) }
end
