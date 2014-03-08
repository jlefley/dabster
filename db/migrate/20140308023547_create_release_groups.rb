Sequel.migration do
  change do
    create_table :release_groups do
      primary_key :id
      Integer :library_album_id, index: true, null: false
      Integer :torrent_group_id, index: true, null: false
      String :name
      String :artist
      String :tags
      Integer :year
      String :type
      String :artists
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
