Sequel.migration do
  change do
    create_table :similar_artists_relationships do
      foreign_key :artist_id, :artists, null: false
      foreign_key :similar_artist_id, :artists, null: false, index: true
      Integer :whatcd_score, null: false
      primary_key [:artist_id, :similar_artist_id]
    end
  end
end
