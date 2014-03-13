Sequel.migration do
  change do
    create_table :artist_library_item_relationships do
      primary_key :id
      foreign_key :artist_id, :artists, null: false, on_delete: :cascade
      Integer :library_item_id, null: false, index: true
      String :type, null: false
      unique [:artist_id, :library_item_id, :type]
      index [:artist_id, :library_item_id]
    end
  end
end
