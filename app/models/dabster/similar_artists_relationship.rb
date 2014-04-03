module Dabster
  class SimilarArtistsRelationship < Sequel::Model
    unrestrict_primary_key
    many_to_one :similar_artist, class: 'Dabster::Artist'

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
end
