Sequel.migration do
  change do
    create_table :library_item_playbacks do
      primary_key :id
      foreign_key :playlist_id, :playlists, null: false
      Integer :library_item_id, null: false
      DateTime :playback_started_at, null: false
    end
  end
end
