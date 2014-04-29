Sequel::Model.db.create_table(:libdb__items) do
  primary_key :id
  String :title
  String :artist
end
