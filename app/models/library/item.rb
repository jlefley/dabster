module Library
  class Item < Sequel::Model(:libdb__items)
    many_to_one :library_album, class: 'Library::Album', key: :album_id
  end
end
