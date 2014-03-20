module Library
  class Item < Sequel::Model(:libdb__items)
    plugin :categorized_relationship
    many_to_one :library_album, class: 'Library::Album', key: :album_id
    categorized_relationship :artists, class: 'Artist', relationship_class: 'ArtistLibraryItemRelationship',
      left_key: :library_item_id
  end
end
