module Dabster
  module Library
    class Item < Sequel::Model(:libdb__items)
      plugin :categorized_relationship
      plugin :many_through_many

      many_to_one :library_album, class: 'Dabster::Library::Album', key: :album_id
      one_to_many :playbacks, class: 'Dabster::LibraryItemPlayback', key: :library_item_id
      many_to_many :all_similar_artist_relationships, class: 'Dabster::SimilarArtistsRelationship',
        join_table: :artist_library_item_relationships, right_key: :artist_id, left_key: :library_item_id
      categorized_relationship :artists, class: 'Dabster::Artist', relationship_class: 'Dabster::ArtistLibraryItemRelationship',
        left_key: :library_item_id, join_table: :artist_library_item_relationships
      many_through_many :all_similar_artists, class: 'Dabster::Artist', distinct: true, through: [
        [:artist_library_item_relationships, :library_item_id, :artist_id],
        [:artists, :id, :id], [:similar_artists_relationships, :artist_id, :similar_artist_id]
      ]

      def similar_artists
        all_similar_artists_dataset.exclude(similar_artist_id: artist_id_filter).all
      end

      def similar_artist_relationships
        all_similar_artist_relationships_dataset.exclude(similar_artist_id: artist_id_filter).all
      end

      def weighted_similar_artists
        normalizer = Logic::SimilarArtistsNormalizer.new(similar_artists)
        normalizer.assign_similarity_scores(similar_artist_relationships)
        normalizer.assign_last_played_scores
        artists
      end

      private
      
      def artist_id_filter
        all_similar_artist_relationships_dataset.select(:similar_artists_relationships__artist_id)
      end

    end
  end
end
