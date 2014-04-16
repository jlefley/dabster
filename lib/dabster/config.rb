require 'configuration'

module Dabster
  def self.configure(file)
    load(file)
    @config = Configuration.for(ENV['DABSTER_ENV'])
  end
  
  def self.config
    @config
  end
end
