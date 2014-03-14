module Library
  class Item < Sequel::Model(:libdb__items)
    many_to_one :library_album, class: 'Library::Album', key: :album_id
    one_to_many :artist_relationships, class: 'ArtistLibraryItemRelationship', key: :library_item_id
    many_to_many :artists, class: 'Artist', join_table: :artist_library_item_relationships, left_key: :library_item_id

=begin
  def artists(type=nil)
    unless type.nil? || valid_artist_relationship_types.include?(type.to_s)
      raise(ArgumentError, "type must be one of #{valid_artist_relationship_types}")
    end
    if type
      artists_dataset.where(type: type.to_s).all
    else
      mapping = Hash.new { |hash, key| hash[key] = [] }
      relationships = artist_relationships
      artists = super().uniq
      relationships.each do |rel|
        mapping[rel.type.to_s] << artists.select { |a| a.id == rel.artist_id }.first
      end
      mapping
    end
  end
=end

  def artists
    raise NotImplemented
  end

  private

  def _add_artist(artist, *args)
    raise(ArgumentError, 'expected 2 arguments, artist and artist relationship type') unless type = args.first
    add_artist_relationship(artist_id: artist.id, type: type.to_s)
  end

  def _remove_artist(artist, *args)
    raise(ArgumentError, 'expected 2 arguments, artist and artist relationship type') unless type = args.first.to_s
    unless valid_artist_relationship_types.include?(type)
      raise(ArgumentError, "type must be one of #{valid_artist_relationship_types}")
    end
    rel = artist_relationships_dataset.where(artist_id: artist.id, type: type).first
    raise(Sequel::Error, "associated object #{artist.inspect} is not currently associated to #{inspect} as #{type}") unless rel
    rel.destroy
  end

  def valid_artist_relationship_types
    artist_relationships_dataset.association_reflection[:cache][:class]::TYPES
  end

  end
end
