Sequel.migration do
  change do
    create_table :artist_group_relationships do
      primary_key :id
      foreign_key :artist_id, :artists, null: false, on_delete: :cascade
      foreign_key :group_id, :groups, null: false, index: true, on_delete: :cascade
      String :type, null: false
      unique [:artist_id, :group_id, :type]
      index [:artist_id, :group_id]
    end
  end
end
