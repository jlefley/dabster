class SimilarArtistsRelationship < Sequel::Model
  unrestrict_primary_key
  many_to_one :similar_artist, class: 'Artist', graph_join_type: :inner

  def similar_artist_name
    similar_artist.whatcd_name
  end

  def validate
    super

    validates_presence :whatcd_score
    validates_presence :artist_id
    validates_presence :similar_artist_id
  end

end
