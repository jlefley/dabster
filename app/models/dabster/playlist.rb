module Dabster
  class Playlist < Sequel::Model
    one_to_many :items, class: 'Dabster::PlaylistItem'
    many_to_many :initial_artists, class: 'Dabster::Artist', join_table: :playlist_initial_artist_relationships

    def current_item
      item_by_relative_position(0)
    end

    def next_item
      item_by_relative_position(1)
    end

    def item_by_relative_position(offset_from_current_position)
      if item = items[current_position + offset_from_current_position]
        item
      else
        initial_artist = initial_artists.first
        if items.empty?
          # Select item from the initial artist
          item = initial_artist.least_played_item
        else
          # Select item from artist similar to initial artist
          initial_artist.sorted_similar_artists.each do |artist|
            break if item = artist.least_played_item
          end
        end
        add_item(library_item: item, position: current_position + offset_from_current_position)
        item
      end
    end

  end
end
