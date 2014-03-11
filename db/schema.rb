Sequel.migration do
  change do
    create_table(:groups) do
      primary_key :id
      column :library_album_id, "integer", :null=>false
      column :what_id, "integer"
      column :what_artist, "varchar(255)"
      column :what_name, "varchar(255)"
      column :what_tags, "varchar(255)"
      column :what_year, "integer"
      column :what_release_type, "varchar(255)"
      column :what_artists, "varchar(255)"
      column :what_confidence, "double precision"
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
      
      index [:library_album_id]
      index [:what_id]
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
