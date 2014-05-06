module Dabster
  class PlaylistItem < Sequel::Model
    many_to_one :library_item, class: 'Dabster::Library::Item'
    many_to_one :artist, class: 'Dabster::Artist'

    def title
      library_item.title
    end

    def artist
      library_item.artist
    end

    def path
      library_item.path
    end

    def add_playback
      library_item.add_playback
    end

  end
end
