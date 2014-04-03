Sequel.migration do
  up do
    drop_table :what_api_result_groups
  end

  down do
    create_table :what_api_result_groups do
    end
  end
end
