Sequel.migration do
  change do
    create_table :playlist_initial_artist_relationships do
      foreign_key :initial_artist_id, :artists, null: false
      foreign_key :playlist_id, :playlists, null: false
      primary_key [:initial_artist_id, :playlist_id]
      index :playlist_id
    end
  end
end
