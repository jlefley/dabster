Sequel.migration do
  change do
    create_table(:artists) do
      primary_key :id
      column :name, "varchar(255)"
      column :what_id, "integer"
      column :what_name, "varchar(255)"
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp"
      
      index [:what_id]
    end
    
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
    
    create_table(:artists_groups) do
      foreign_key :artist_id, :artists, :null=>false, :on_delete=>:cascade
      foreign_key :group_id, :groups, :null=>false, :on_delete=>:cascade
      
      primary_key [:artist_id, :group_id]
      
      index [:group_id]
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140308023547_create_release_groups.rb')"
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140311194900_create_artists.rb')"
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140311195146_create_artists_groups.rb')"
  end
end
