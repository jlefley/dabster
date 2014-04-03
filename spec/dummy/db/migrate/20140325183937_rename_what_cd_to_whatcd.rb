Sequel.migration do
  up do
    rename_table :what_cd_torrent_group_responses, :whatcd_torrent_group_responses
    rename_table :what_cd_artist_responses, :whatcd_artist_responses
    rename_table :what_cd_release_types, :whatcd_release_types
    drop_table :what_cd_api_info
  end

  down do
    rename_table :whatcd_torrent_group_responses, :what_cd_torrent_group_responses
    rename_table :whatcd_artist_responses, :what_cd_artist_responses
    rename_table :whatcd_release_types, :what_cd_release_types
  end
end
