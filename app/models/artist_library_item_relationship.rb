class ArtistLibraryItemRelationship < Sequel::Model
  many_to_one :artist

  def validate
    super
    validates_includes ArtistGroupRelationship::TYPES, :type
    validates_presence :confidence
  end

  def artist_name
    artist.whatcd_name
  end

  dataset_module do
    def no_library_item
      select_all(:artist_library_item_relationships).left_join(:libdb__items, id: :library_item_id).where(items__id: nil)
    end
  end
end
