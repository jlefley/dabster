Sequel.migration do
  change do
    create_table :groups do
      primary_key :id
      Integer :library_album_id, index: true, null: false, unique: true
      Integer :what_id, unique: true
      String :what_artist_name
      String :what_artist_type
      foreign_key :what_artist_id, :artists, index: true
      String :what_name
      String :what_tags
      Integer :what_year
      String :what_release_type
      String :what_artists
      String :what_record_label
      String :what_catalog_number
      Float :what_confidence
      DateTime :created_at, null: false
      DateTime :updated_at
    end
  end
end
