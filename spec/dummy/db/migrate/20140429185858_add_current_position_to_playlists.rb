Sequel.migration do
  change do
    alter_table :playlists do
      add_column :current_position, Integer
    end
  end
end
