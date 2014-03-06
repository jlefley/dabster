Sequel.migration do 
  change do

    create_table :what_api_infos do
      Time :last_request
      String :cookie
    end

  end
end
