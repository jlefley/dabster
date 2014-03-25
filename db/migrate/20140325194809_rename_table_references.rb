Sequel.migration do
  up do
    transaction do
      rename_table :artist_group_relationships, :old_artist_group_relationships
      rename_table :artist_library_item_relationships, :old_artist_library_item_relationships
      rename_table :similar_artists_relationships, :old_similar_artists_relationships
      run 'DROP INDEX artist_group_relationships_group_id_index'
      run 'DROP INDEX artist_group_relationships_artist_id_group_id_index'
      run 'DROP INDEX artist_library_item_relationships_library_item_id_index'
      run 'DROP INDEX artist_library_item_relationships_artist_id_library_item_id_index'
      run 'DROP INDEX similar_artists_relationships_similar_artist_id_index'
      create_table :artist_group_relationships do
        primary_key :id
        foreign_key :artist_id, :artists, null: false, on_delete: :cascade
        foreign_key :group_id, :groups, null: false, index: true, on_delete: :cascade
        String :type, null: false
        unique [:artist_id, :group_id, :type]
        index [:artist_id, :group_id]
      end
      create_table :artist_library_item_relationships do
        primary_key :id
        foreign_key :artist_id, :artists, null: false, on_delete: :cascade
        Integer :library_item_id, null: false, index: true
        String :type, null: false
        TrueClass :group_artist, null: false, default: false
        Float :confidence, null: false
        unique [:artist_id, :library_item_id, :type, :group_artist]
        index [:artist_id, :library_item_id]
      end
      create_table :similar_artists_relationships do
        foreign_key :artist_id, :artists, null: false
        foreign_key :similar_artist_id, :artists, null: false, index: true
        Integer :whatcd_score, null: false
        primary_key [:artist_id, :similar_artist_id]
      end
      run 'INSERT INTO artist_group_relationships (id, artist_id, group_id, type) SELECT id, artist_id, group_id, type FROM old_artist_group_relationships;'
      run 'INSERT INTO artist_library_item_relationships (id, artist_id, library_item_id, type, group_artist, confidence) SELECT id, artist_id, library_item_id, type, group_artist, confidence FROM old_artist_library_item_relationships;'
      run 'INSERT INTO similar_artists_relationships (artist_id, similar_artist_id, whatcd_score) SELECT artist_id, similar_artist_id, whatcd_score FROM old_similar_artists_relationships;'
      drop_table :old_artist_group_relationships
      drop_table :old_artist_library_item_relationships
      drop_table :old_similar_artists_relationships
      drop_table? :old_groups
      drop_table? :old_artists
    end
  end

  down do
    raise Sequel::Error
  end
end
