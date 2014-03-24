Sequel.migration do
  change do
    create_table :what_cd_release_types do
      Integer :id, primary_key: true
      String :name, null: false
    end
  end
end
