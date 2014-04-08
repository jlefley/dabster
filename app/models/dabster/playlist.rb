module Dabster
  class Playlist < Sequel::Model
    many_to_one :initial_artist, class: 'Dabster::Artist'
    many_to_one :initial_library_item, class: 'Dabster::Library::Item'
    many_to_many :items, class: 'Dabster::Library::Item', join_table: :library_item_playbacks, right_key: :library_item_id
    one_to_many :library_item_playbacks, class: 'Dabster::LibraryItemPlayback'

    def items_dataset
      Dabster::Library::Item.join(:library_item_playbacks, [[:library_item_id, :items__id], [:playlist_id, id]]).
        select_all(:items)
    end

    def last_played_item
      items_dataset.order(:playback_started_at).reverse.first
    end

    private

    def _add_item(item)
      add_library_item_playback(library_item_id: item.id)
    end

  end
end
