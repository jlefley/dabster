module Library
  class Item < Sequel::Model(:libdb__items)
    many_to_one :library_album, class: 'Library::Album', key: :album_id
    many_to_many :artists, class: 'Artist', join_table: :artists_library_items, left_key: :library_item_id
  end
end
