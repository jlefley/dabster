Sequel.migration do
  change do
    create_table :playlists do
      primary_key :id
      foreign_key :initial_artist_id, :artists
      Integer :initial_library_item_id
      DateTime :created_at, null: false
    end
  end
end
