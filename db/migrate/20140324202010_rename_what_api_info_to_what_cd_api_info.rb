Sequel.migration do
 change do
    rename_table :what_api_info, :what_cd_api_info
  end
end
