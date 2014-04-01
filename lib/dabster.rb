require 'json'
require 'sequel'
require 'htmlentities'
require 'similar_text'
require 'fuzzy_match'
require 'yaml'
require 'fileutils'

require 'dabster/version'
require 'dabster/sequel'

module Dabster
  class Error < StandardError; end

  @config = {
    library_database: "#{Dir.home}/.config/beets/library.db",
    database:         "#{Dir.home}/.config/dabster/dabster.sqlite3",
    log:              "#{Dir.home}/.config/dabster/dabster.log",
    whatcd_username:  '',
    whatcd_password:  ''
  }

  @valid_config_keys = @config.keys

  def self.configure(opts={})
    if !opts.is_a?(Hash)
      log(:warning, 'Config file invalid. Using defaults.')
      return
    end
    opts.each do |k, v|
      k = k.to_sym
      if @valid_config_keys.include?(k)
        raise(Dabster::Error, "#{k} directory does not exist") if [:database, :log].include?(k) && !File.directory?(File.dirname(v))
        @config[k] = v
      end
    end
  end

  def self.configure_with(config_file_path)
    configure(YAML.load(IO.read(config_file_path)))
  rescue Errno::ENOENT
    log(:warning, 'Config file could not be found. Using defaults.')
  rescue Psych::SyntaxError
    log(:warning, 'Config file contains invalid syntax. Using defaults.')
  end

  def self.log(level, msg)
    File.open(config[:log], 'a') do |file|
      file.puts("[#{level} #{Time.now}]")
      file.puts(msg)
      file.write("\n")
    end
  end

  def self.config
    @config
  end

  def self.initialize
    # Create config directory
    FileUtils.mkdir_p("#{Dir.home}/.config/dabster")

    # Load config
    configure_with("#{Dir.home}/.config/dabster/config.yml")
  end

  def self.initialize_db
    # Should be called after database connection is established

    # Attach library db
    if File.exists?(config[:library_database])
      Sequel::Model.db.run("ATTACH DATABASE '#{config[:library_database]}' AS libdb")
    else
      raise(Dabster::Error, "library database (#{config[:library_database]}) could not be found")
    end

    # Load structure if not already
    if !Sequel::Model.db.table_exists?(:groups)
      puts '[Dabster] Initializing database with structure'
      Sequel::Model.db.run(File.read(File.join(root, 'db', 'structure.sql')))
    end
    
    # Load seeds if not already
    if Sequel::Model.db[:whatcd_release_types].count == 0
      puts '[Dabster] Loading seed data into database'
      load(File.join(root, 'db', 'seeds.rb'))
    end
  end

  def self.root
    @root ||= File.expand_path('../..', __FILE__)
  end

end

if defined?(Rails)
  require 'dabster/engine'
else
  require 'ruby-progressbar'
  require 'thor'
  require 'dabster/cli'

  Dabster.initialize
  Sequel.sqlite(Dabster.config[:database])
  Dabster.initialize_db
  
  %w(whatcd services logic scrapers).each do |dir|
    Dir["#{Dabster.root}/lib/dabster/#{dir}/**/*.rb"].each { |f| require(f) }
  end

  Dir["#{Dabster.root}/app/models/dabster/**/*.rb"].each { |f| require(f) }
end
