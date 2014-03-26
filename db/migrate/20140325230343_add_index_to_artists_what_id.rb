Sequel.migration do
  change do
    alter_table :artists do
      add_index :whatcd_id
    end
  end
end
