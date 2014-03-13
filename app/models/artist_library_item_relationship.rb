class ArtistLibraryItemRelationship < Sequel::Model
  TYPES = %w(composer dj artist with conductor remixed_by producer)

  def validate
    super
    validates_includes TYPES, :type
  end
end
