Sequel.migration do
  up do
    transaction do
      rename_table :artists, :old_artists
      create_table :artists do
        primary_key :id
        Integer :whatcd_id, unique: true
        String :whatcd_name
        DateTime :whatcd_updated_at
        DateTime :created_at, null: false
        DateTime :updated_at
      end
      run 'INSERT INTO artists (id, whatcd_id, whatcd_name, whatcd_updated_at, created_at, updated_at) SELECT id, what_id, what_name, what_updated_at, created_at, updated_at FROM old_artists;'
    end
  end

  down do
    raise Sequel::Error, 'cannot reverse table migration'
  end
end
