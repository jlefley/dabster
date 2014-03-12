Sequel.migration do
  change do
    create_table :artists_library_items do
      foreign_key :artist_id, :artists, null: false, on_delete: :cascade
      Integer :library_item_id, null: false, index: true
      primary_key [:artist_id, :library_item_id]
    end
  end
end
