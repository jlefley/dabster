Sequel.migration do
  up do
    create_table :what_cd_torrent_group_responses do
      Integer :id, primary_key: true
      String :response, null: false
      DateTime :updated_at, null: false
    end
    run 'INSERT INTO what_cd_torrent_group_responses (id, response, updated_at) SELECT group_id, response, updated_at FROM what_api_torrent_groups;'
    drop_table :what_api_torrent_groups
  end
  down do
    raise Sequel::Error, 'cant reverse table rename'
  end
end
