Sequel.migration do
  change do
    create_table :artists do
      primary_key :id
      Integer :what_id, unique: true
      String :what_name
      DateTime :created_at, null: false
      DateTime :updated_at
    end
  end
end
