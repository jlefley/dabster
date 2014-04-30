Sequel::Model.db.create_table(:libdb__items) do
  primary_key :id
  Integer :album_id
  String :album
  String :title
  String :artist
  String :path
end

Sequel::Model.db.create_table(:libdb__albums) do
  primary_key :id
end
