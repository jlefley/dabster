module Dabster
  module Recommenders
    class PlayAll

      def select_item(artist)
        return artist.random_unplayed_item || artist.least_recently_played_item
      end

      def select_artist(item)
        similar_artists = item.weighted_similar_artists
        if !(unplayed_artists = similar_artists.select { |a| a.last_played_score.nil? }).empty?
          unplayed_artists.sort { |a, b| b.similarity_score <=> a.similarity_score }.first
        else
          similar_artists.sort { |a, b| combine_scores(b) <=> combine_scores(a) }.first
        end
      end

      private

      def combine_scores(a)
        0.5 * (a.similarity_score + a.last_played_score)
      end

    end
  end
end
