Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:what_api_infos) do
      column :last_request, "timestamp"
      column :cookie, "varchar(255)"
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140305223605_create_what_api_infos.rb')"
  end
end
