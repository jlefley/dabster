module Dabster
  module Logic
    class SimilarArtistsNormalizer

      def initialize(artists)
        @artists = artists
      end

      def assign_similarity_scores(relationships)
        max = relationships.max_by { |r| r.whatcd_score }.whatcd_score.to_f
        @artists.each do |artist|
          artist.similarity_score =
            relationships.select { |r| r.similar_artist_id == artist.id }.reduce(0) { |sum, r| sum += r.whatcd_score }.to_f / max
        end
      end

      def assign_last_played_scores
        played_artists = @artists.select { |a| !a.last_played_at.nil? }
        return if played_artists.empty?
        max = played_artists.max_by { |a| a.last_played_at }.last_played_at.to_f
        min = played_artists.min_by { |a| a.last_played_at }.last_played_at.to_f
        delta = max - min
        played_artists.each do |artist|
          artist.last_played_score = 1.0 - ((artist.last_played_at.to_f - min) / delta)
        end
      end

    end
  end
end
