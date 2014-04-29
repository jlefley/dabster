Sequel.migration do
  change do
    create_table :playlists do
      primary_key :id
      DateTime :created_at, null: false
    end
  end
end
