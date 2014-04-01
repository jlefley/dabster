module Dabster
  module Library
    class Item < Sequel::Model(:libdb__items)
      plugin :categorized_relationship
      many_to_one :library_album, class: 'Dabster::Library::Album', key: :album_id
      categorized_relationship :artists, class: 'Dabster::Artist', relationship_class: 'Dabster::ArtistLibraryItemRelationship',
        left_key: :library_item_id
    end
  end
end
