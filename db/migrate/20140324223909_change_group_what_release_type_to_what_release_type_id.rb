Sequel.migration do
  up do
    alter_table :groups do
      add_foreign_key :what_release_type_id, :what_cd_release_types
      drop_column :what_release_type
    end
  end

  down do
    alter_table :groups do
      add_column :what_release_type, String
      drop_column :what_release_type_id
    end
  end
end
