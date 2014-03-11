Sequel.migration do
  change do
    create_table :groups do
      primary_key :id
      Integer :library_album_id, index: true, null: false, unique: true
      Integer :what_id, index: true
      String :what_artist
      String :what_name
      String :what_tags
      Integer :what_year
      String :what_release_type
      String :what_artists
      Float :what_confidence
      DateTime :created_at, null: false
      DateTime :updated_at
    end
  end
end
