Sequel.migration do
  change do
    create_table :whatcd_similar_artists_responses do
      Integer :id, primary_key: true
      String :response, null: false
      DateTime :updated_at, null: false
    end
  end
end
