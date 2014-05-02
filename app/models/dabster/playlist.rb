module Dabster
  class Playlist < Sequel::Model
    one_to_many :items, class: 'Dabster::PlaylistItem'
    many_to_many :initial_artists, class: 'Dabster::Artist', join_table: :playlist_initial_artist_relationships

    def initialize_with_artist(artist)
      db.transaction do
        add_initial_artist(artist)
        update(current_position: 0)
        add_item(library_item: select_item, position: 0)
      end
    end

    def increment_current_position
      update(current_position: current_position + 1)
    end

    def current_item
      items[current_position]
    end

    def next_item
      next_position = current_position + 1
      
      if !(item = items[next_position])
        # No item at new position, need to dynamically select the next item
        add_item(library_item: item = select_item, position: next_position)
      end

      item
    end

    private

    def select_item
      initial_artist = initial_artists.first
      
      if items.empty?
        # Select item from the initial artist
        initial_artist.least_played_item
      else
        # Select item from artist similar to initial artist
        initial_artist.sorted_similar_artists.each do |artist|
          if item = artist.least_played_item
            return item
          end
        end
      end
    end

  end
end
