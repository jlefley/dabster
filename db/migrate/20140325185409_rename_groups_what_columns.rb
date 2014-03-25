Sequel.migration do
  up do
    transaction do
      run 'DROP INDEX groups_library_album_id_index'
      rename_table :groups, :old_groups
      create_table :groups do
        primary_key :id
        Integer :library_album_id, index: true, null: false, unique: true
        Integer :whatcd_id
        String :whatcd_name
        String :whatcd_tags
        Integer :whatcd_year
        String :whatcd_artists
        String :whatcd_record_label
        String :whatcd_catalog_number
        foreign_key :whatcd_release_type_id, :whatcd_release_types
        Float :whatcd_confidence
        DateTime :whatcd_updated_at
        DateTime :created_at, null: false
        DateTime :updated_at
      end
      run 'INSERT INTO groups (id, library_album_id, whatcd_id, whatcd_name, whatcd_tags, whatcd_year, whatcd_artists, whatcd_record_label, whatcd_catalog_number, whatcd_release_type_id, whatcd_confidence, whatcd_updated_at, created_at, updated_at) SELECT id, library_album_id, what_id, what_name, what_tags, what_year, what_artists, what_record_label, what_catalog_number, what_release_type_id, what_confidence, what_updated_at, created_at, updated_at FROM old_groups;'
    end
  end

  down do
    raise Sequel::Error, 'cannot reverse table migration'
  end
end
