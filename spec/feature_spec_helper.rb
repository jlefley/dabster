ENV['RAILS_ENV'] ||= 'test'
require 'support/dummy_xmms_client'
require File.expand_path('../../spec/dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

Dabster.initialize_db
load File.expand_path('../../db/library_schema.rb', __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(Dabster.root, 'spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
