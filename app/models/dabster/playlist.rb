module Dabster
  class Playlist < Sequel::Model
    one_to_many :items, class: 'Dabster::PlaylistItem'

    def current_item
      items[current_position]
    end
  end
end
