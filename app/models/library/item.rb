module Library
  class Item < Sequel::Model(:libdb__items)
    many_to_one :library_album, class: 'Library::Album', key: :album_id

  private

  def _remove_artist(artist, *args)
    raise(ArgumentError, 'expected 2 arguments, artist and artist relationship type') unless type = args.first.to_s
    unless valid_artist_relationship_types.include?(type)
      raise(ArgumentError, "type must be one of #{valid_artist_relationship_types}")
    end
    rel = artist_relationships_dataset.where(artist_id: artist.id, type: type).first
    raise(Sequel::Error, "associated object #{artist.inspect} is not currently associated to #{inspect} as #{type}") unless rel
    rel.destroy
  end

  end
end
