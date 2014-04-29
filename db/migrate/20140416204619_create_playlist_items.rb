Sequel.migration do
  change do
    create_table :playlist_items do
      primary_key :id
      foreign_key :playlist_id, :playlists, null: false
      Integer :library_item_id, null: false
      Integer :position, null: false
      DateTime :created_at, null: false
      index [:playlist_id, :position], unique: true
    end
  end
end
