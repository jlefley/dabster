class SimilarArtistsRelationship < Sequel::Model
  unrestrict_primary_key
  many_to_one :similar_artist, class: 'Artist', graph_join_type: :inner

  def similar_artist_name
    similar_artist.what_name
  end

end
