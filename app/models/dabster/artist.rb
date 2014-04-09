module Dabster
  class Artist < Sequel::Model
    attr_accessor :similarity_score, :last_played_score

    plugin :categorized_relationship

    categorized_relationship :groups, class: 'Dabster::Group', relationship_class: 'Dabster::ArtistGroupRelationship',
      join_table: :artist_group_relationships
    categorized_relationship :items, class: 'Dabster::Library::Item', join_table: :artist_library_item_relationships,
      relationship_class: 'Dabster::ArtistLibraryItemRelationship', right_key: :library_item_id
    one_to_many :similar_artist_relationships, class: 'Dabster::SimilarArtistsRelationship'
    many_to_many :similar_artists, class: self, join_table: :similar_artists_relationships
    many_to_many :library_item_playbacks, class: 'Dabster::LibraryItemPlayback',
      join_table: :artist_library_item_relationships, right_key: :library_item_id, right_primary_key: :library_item_id

    def similar_artist_relationships_ordered_by_score
      similar_artist_relationships_dataset.eager_graph_with_options(:similar_artist, join_type: :inner).
        order(:whatcd_score).reverse.all
    end

    def items_dataset
      Dabster::Library::Item.join(:artist_library_item_relationships, [[:library_item_id, :items__id], [:artist_id, id]]).
        select_all(:items)
    end

    def validate
      super
      
      if whatcd_id
        validates_presence :whatcd_name
        validates_presence :whatcd_updated_at
      end
    end

    def last_played_at
      @last_played_at ||= library_item_playbacks_dataset.select_more { max(:playback_started_at) }.first.playback_started_at
    end

    def least_recently_played_item
      items_dataset.where(p2__id: nil).order(:p1__playback_started_at).
        join(:library_item_playbacks, { library_item_id: :items__id }, table_alias: :p1).
        left_join(:library_item_playbacks, { library_item_id: :items__id }, table_alias: :p2) { |j, lj, js|
          Sequel.qualify(j, :playback_started_at) > Sequel.qualify(lj, :playback_started_at)
        }.first
    end

    def random_unplayed_item
      items_dataset.left_join(:library_item_playbacks, { library_item_id: :items__id }, table_alias: :p).where(p__id: nil).
        order{ random{} }.first
    end

    def similar_artists_with_items
      similar_artists_dataset.
        join(:artist_library_item_relationships, { rel__artist_id: :artists__id }, table_alias: :rel).distinct.all
    end

    def weighted_similar_artists
      normalizer = Logic::SimilarArtistsNormalizer.new(weighted_artists = similar_artists_with_items)
      normalizer.assign_similarity_scores(similar_artist_relationships)
      normalizer.assign_last_played_scores
      weighted_artists
    end

    private

    def _add_similar_artist(artist, options)
      add_similar_artist_relationship(options.merge(similar_artist_id: artist.id))
    end
  end
end
