Sequel::Model.plugin :timestamps 
Sequel::Model.plugin :serialization
Sequel::Model.plugin :validation_helpers
Sequel::Model.default_set_fields_options[:missing] = :raise

module Sequel
  def self.parse_json(json)
    JSON.parse(json, create_additions: false, symbolize_names: true)
  end
end
