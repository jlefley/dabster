module Dabster
  class Playlist < Sequel::Model
    one_to_many :items, class: 'Dabster::PlaylistItem'
    many_to_many :initial_artists, class: 'Dabster::Artist', join_table: :playlist_initial_artist_relationships

    def initialize_with_artist(artist)
      db.transaction do
        add_initial_artist(artist)
        update(current_position: 0)
        add_item(library_item: artist.least_played_item, position: 0)
      end
    end

    def increment_current_position
      update(current_position: current_position + 1)
    end

    def current_item
      items[current_position]
    end

    def next_item
      next_position = current_position + 1
      items[next_position] || add_item(library_item: select_item, position: next_position)
    end

    private

    def select_item
     
      if items.empty?
        # Select item from the initial artist
        initial_artist.least_played_item
      else
        relationships = SimilarArtistsRelationship.find_by_artists(initial_artists, 1)
        artists = Artist.where(artists__id: relationships.map { |r| r.similar_artist_id }).having_items.
          eager(:library_item_playbacks).all
        weighted_artists = RecommendationEngineCore.weigh_artist_similarity(artists, relationships)
        weighted_artists = RecommendationEngineCore.weigh_artist_last_playback(weighted_artists)
        sorted_artists = RecommendationEngineCore.sort_artists(weighted_artists)
        Artist.first(id: sorted_artists.first.id).least_played_item
      end
    end
   
  end
end
