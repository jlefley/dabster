Sequel.migration do
  up do
    drop_table?(:what_api_info)
    drop_table?(:what_cd_api_info)
  end

  down do
  end
end
