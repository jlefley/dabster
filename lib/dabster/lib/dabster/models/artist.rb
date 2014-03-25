class Artist < Sequel::Model
  plugin :categorized_relationship
  categorized_relationship :groups, class: 'Group', relationship_class: 'ArtistGroupRelationship'
  categorized_relationship :items, class: 'Library::Item', relationship_class: 'ArtistLibraryItemRelationship',
    right_key: :library_item_id
  one_to_many :similar_artists, class: 'SimilarArtistsRelationship', eager_graph: :similar_artist

  def items_dataset
    Library::Item.join(:artist_library_item_relationships, [[:library_item_id, :items__id], [:artist_id, id]]).select_all(:items)
  end

  def validate
    super
    
    if whatcd_id
      validates_presence :whatcd_name
      validates_presence :whatcd_updated_at
    end
  end
end
