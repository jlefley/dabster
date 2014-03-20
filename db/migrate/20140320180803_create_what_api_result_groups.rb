Sequel.migration do
  change do
    create_table :what_api_result_groups do
      primary_key :id
      Integer :group_id
      String :response
      DateTime :created_at, null: false
    end
  end
end
