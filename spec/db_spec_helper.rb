# Set the environment to test
ENV['DABSTER_ENV'] ||= 'test'

# Run each example in a database transaction
require 'support/database_cleaner'

# Load library without rails components
require 'dabster'

# Load library database schema
require 'support/library_database'

RSpec.configure do |config|
  config.order = 'random'
end
