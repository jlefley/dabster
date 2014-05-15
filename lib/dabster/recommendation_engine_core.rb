require 'ostruct'

module Dabster
  module RecommendationEngineCore
    module_function

    def weigh_artist_similarity(artists, relationships)
      max_whatcd_score = relationships.select { |r| r.distance != 0 }.max_by { |r| r.whatcd_score }.whatcd_score.to_f

      artists.map do |artist|
        artist_relationships = relationships.select { |r| r.similar_artist_id == artist.id }
        identity_relationship = artist_relationships.select { |r| r.distance == 0 }.first

        if identity_relationship
          similarity_score = 1.0
        else
          similarity_score = (artist_relationships.reduce(0) { |sum, r| sum += r.whatcd_score }.to_f - 0.01) / max_whatcd_score
        end
        OpenStruct.new(artist.marshal_dump.merge(similarity_score: similarity_score))
      end
    end

    def weigh_artist_last_playback(artists)
      played_artists = artists.select { |a| !a.last_played_at.nil? }
      if !played_artists.empty?
        max = played_artists.max_by { |a| a.last_played_at }.last_played_at.to_f
        min = played_artists.min_by { |a| a.last_played_at }.last_played_at.to_f
        delta = max - min
      end

      artists.map do |artist|
        if played_artists.include?(artist)
          if played_artists.length == 1
            last_played_score = 0.0
          else
            last_played_score = 1.0 - ((artist.last_played_at.to_f - min) / delta)
          end
        else
          last_played_score = nil
        end

        OpenStruct.new(artist.marshal_dump.merge(last_played_score: last_played_score))
      end
    end

    def sort_artists(artists)
      if !(unplayed_artists = artists.select { |a| a.last_played_score.nil? }).empty?
        unplayed_artists.sort { |a, b| b.similarity_score <=> a.similarity_score }
      else
        artists.sort { |a, b| combine_scores(b) <=> combine_scores(a) }
      end
    end

    def combine_scores(a)
      0.5 * (a.similarity_score + a.last_played_score)
    end

  end
end
