module Dabster
  module Playlists
    class ArtistGraphDepthFirstDynamicPlaylist
     
      attr_reader :playlist, :recommender

      def initialize(playlist, recommender)
        @playlist, @recommender = playlist, recommender
      end

      def next_item
        if last_item = playlist.last_played_item
          artists = recommender.select_artists_by_item(last_item)
          raise(Dabster::PlaylistError, "#{last_item.inspect} has no artists available") if artists.empty?
          artists.each do |artist|
            if item = recommender.select_item(artist)
              playlist.add_item(item)
              return item 
            end
          end
          raise(Dabster::PlaylistError, "#{last_item.inspect} has no artists with items available")
        else
          initial_artist = playlist.initial_artist
          if item = recommender.select_item(initial_artist)
            playlist.add_item(item)
            return item
          else
            raise(Dabster::PlaylistError, "#{initial_artist.inspect} has no items available")
          end
        end
      end

    end
  end
end
