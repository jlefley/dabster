module Dabster
  module Playlists
    class ArtistGraphBreadthDynamicPlaylist
     
      attr_reader :playlist, :recommender

      def initialize(playlist, recommender)
        @playlist, @recommender = playlist, recommender
      end

      def next_item
        if playlist.last_played_item
          artists = recommender.select_artists_by_artist(playlist.initial_artist)
          raise(Dabster::PlaylistError, "#{playlist.initial_artist.inspect} has no artists available") if artists.empty?
          artists.each do |artist|
            if item = recommender.select_item(artist)
              playlist.add_item(item)
              return item 
            end
          end
          raise(Dabster::PlaylistError, "#{playlist.initial_artist.inspect} has no artists with items available")
        else
          if item = recommender.select_item(playlist.initial_artist)
            playlist.add_item(item)
            return item
          else
            raise(Dabster::PlaylistError, "#{playlist.initial_artist.inspect} has no items available")
          end
        end
      end

    end
  end
end
