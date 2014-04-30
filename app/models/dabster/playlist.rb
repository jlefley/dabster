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
        item = selector.next_item
        add_item(library_item: item, position: current_position + offset_from_current_position)
        item
      end
    end

  end
end
