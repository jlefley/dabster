require 'database_cleaner'

RSpec.configure do |config|
  config.around :each do |example|
    if example.metadata[:type] == :feature
      DatabaseCleaner.strategy = :truncation
      example.run
      DatabaseCleaner.clean
    else
      Sequel::Model.db.transaction(rollback: :always) { example.run }
    end
  end
end
