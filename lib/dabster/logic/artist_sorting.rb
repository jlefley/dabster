module Dabster
  module Logic
    module ArtistSorting

      def sorted_similar_artists
        similar_artists = weighted_similar_artists
        if !(unplayed_artists = similar_artists.select { |a| a.last_played_score.nil? }).empty?
          unplayed_artists.sort { |a, b| b.similarity_score <=> a.similarity_score }
        else
          similar_artists.sort { |a, b| combine_scores(b) <=> combine_scores(a) }
        end
      end

      def combine_scores(a)
        0.5 * (a.similarity_score + a.last_played_score)
      end

    end
  end
end
