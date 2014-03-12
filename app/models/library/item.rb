module Library
  class Item < Sequel::Model(:libdb__items)
    many_to_one :library_album, class: 'Library::Album', key: :album_id
    many_to_many :artists, join_table: :artists_library_items
  end
end
