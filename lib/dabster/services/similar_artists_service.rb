module Dabster
  module Services
    class SimilarArtistsService

      attr_reader :artist_class

      def initialize(artist_class)
        @artist_class = artist_class
      end

      def relate_artists(artist, artist_relationships)
        existing_relationships = artist.similar_artist_relationships
        artist_relationships.each do |relationship|
          similar_artist = artist_class.first(whatcd_id: relationship.id)
          if similar_artist
            if existing_relationship = existing_relationships.select { |r| r.similar_artist_id == similar_artist.id }.first
              existing_relationship.update(whatcd_score: relationship.score)
            else
              artist.add_similar_artist(similar_artist, whatcd_score: relationship.score)
            end
          end
        end
      end

    end
  end
end
