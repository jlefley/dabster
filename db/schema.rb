Sequel.migration do
  change do
    create_table(:release_groups) do
      primary_key :id
      column :library_album_id, "integer", :null=>false
      column :torrent_group_id, "integer", :null=>false
      column :name, "varchar(255)"
      column :artist, "varchar(255)"
      column :tags, "varchar(255)"
      column :year, "integer"
      column :type, "varchar(255)"
      column :artists, "varchar(255)"
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp", :null=>false
      
      index [:library_album_id]
      index [:torrent_group_id]
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:what_api_info) do
      column :last_request, "timestamp"
      column :cookie, "varchar(255)"
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140308023547_create_release_groups.rb')"
  end
end
