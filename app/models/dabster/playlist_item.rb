module Dabster
  class PlaylistItem < Sequel::Model
    many_to_one :library_item, class: 'Dabster::Library::Item'

    def title
      library_item.title
    end

    def artist
      library_item.artist
    end

    def path
      library_item.path
    end

  end
end
