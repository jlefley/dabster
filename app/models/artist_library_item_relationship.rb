class ArtistLibraryItemRelationship < Sequel::Model
  def validate
    super
    validates_includes ArtistGroupRelationship::TYPES, :type
    validates_presence :confidence
  end
end
