Sequel.migration do
  change do
    create_table :artists_groups do
      foreign_key :artist_id, :artists, null: false, on_delete: :cascade
      foreign_key :group_id, :groups, null: false, index: true, on_delete: :cascade
      primary_key [:artist_id, :group_id]
    end
  end
end
