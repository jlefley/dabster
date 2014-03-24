Sequel.migration do
  up do
    alter_table :groups do
      drop_column :what_artist
    end
  end

  down do
    alter_table :groups do
      add_column :what_artist, String
    end
  end
end
