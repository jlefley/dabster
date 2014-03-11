Sequel::Model.plugin :active_model
Sequel::Model.plugin :timestamps 
Sequel::Model.plugin :serialization
Sequel::Model.plugin :validation_helpers
Sequel::Model.default_set_fields_options[:missing] = :raise
