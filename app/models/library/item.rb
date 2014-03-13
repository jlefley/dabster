module Library
  class Item < Sequel::Model(:libdb__items)
    many_to_one :library_album, class: 'Library::Album', key: :album_id
    one_to_many :artist_relationships, class: 'ArtistLibraryItemRelationship', key: :library_item_id

    def add_artist o, type
      raise(Sequel::Error, "associated object #{o.inspect} not of correct type Artist") unless o.is_a?(Artist)
      raise(Sequel::Error, "model object #{inspect} does not have a primary key") unless pk
      o.save if o.new?
      raise(Sequel::Error, "associated object #{o.inspect} does not have a primary key") unless o.pk
      add_artist_relationship(artist_id: o.id, type: type)
      o
    end

    def remove_artist o, type
      raise(Sequel::Error, "associated object #{o.inspect} not of correct type Artist") unless o.is_a?(Artist)
      raise(Sequel::Error, "model object #{inspect} does not have a primary key") if !pk
      raise(Sequel::Error, "associated object #{o.inspect} does not have a primary key") unless o.pk
      rel = artist_relationships_dataset.where(artist_id: o.id, type: type).first
      raise(Sequel::Error, "associated object #{o.inspect} is not currently associated to #{inspect} as #{type}") unless rel
      rel.destroy
      o
    end

  end
end
