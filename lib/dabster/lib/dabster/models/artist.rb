class Artist < Sequel::Model
  plugin :categorized_relationship
  categorized_relationship :groups, class: 'Group', relationship_class: 'ArtistGroupRelationship'
  categorized_relationship :items, class: 'Library::Item', relationship_class: 'ArtistLibraryItemRelationship',
    right_key: :library_item_id
  one_to_many :similar_artist_relationships, class: 'SimilarArtistsRelationship', eager_graph: :similar_artist
  many_to_many :similar_artists, class: self, join_table: :similar_artists_relationships

  def similar_artist_relationships_ordered_by_score
    similar_artist_relationships_dataset.order(:whatcd_score).reverse.all
  end

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

  private

  def _add_similar_artist(artist, options)
    add_similar_artist_relationship(options.merge(similar_artist_id: artist.id))
  end
end
