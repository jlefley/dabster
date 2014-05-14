module Dabster
  class SimilarArtistsRelationship < Sequel::Model
    unrestrict_primary_key
    many_to_one :similar_artist, class: 'Dabster::Artist'
    many_to_one :artist, class: 'Dabster::Artist'

    class << self
      def find_by_artists(artists, max_distance)
        raise(ArgumentError, 'max distance must be 3 or less') unless max_distance < 4
        artist_ids = artists.map { |a| a.id }
        results = artists.map do |artist|
          base_ds = db[table_name].select(Sequel.as(artist.id, :artist_id), :similar_artist_id, :whatcd_score)
          level0_ds = db.select(Sequel.as(artist.id, :artist_id), Sequel.as(artist.id, :similar_artist_id),
            Sequel.as(0, :whatcd_score), Sequel.as(0, :distance))
          level1_ds = base_ds.select_more(Sequel.as(1, :distance)).where(artist_id: db[:level0].select(:artist_id))
          result_ds = db[:level0].with(:level0, level0_ds).with(:level1, level1_ds).
            union(db[:level1].exclude(similar_artist_id: artist_ids), all: true)
          
          (2..max_distance).each do |d|
            level_ds = base_ds.select_more(Sequel.as(d, :distance)).
              # select all relationships where artist matches similar artist from previous level
              # excluding root artist
              where(artist_id: db["level#{d - 1}".to_sym].select(:similar_artist_id).
                    exclude(similar_artist_id: db[:level0].select(:artist_id))).
              # exclude relationships where similar artist matches similar artist from 2 levels back
              # this exclusion prevents selection of reciprocal relationshps
              exclude(similar_artist_id: db["level#{d - 2}".to_sym].select(:similar_artist_id))
            result_ds = result_ds.with("level#{d}".to_sym, level_ds).
              union(db["level#{d}".to_sym].exclude(similar_artist_id: artist_ids), all: true)
          end

          result_ds.all.map { |d| OpenStruct.new(d) }
        end
        results.flatten
      end
    end

    def distance
      values[:distance]
    end

    def similar_artist_name
      similar_artist.whatcd_name
    end

    def validate
      super

      validates_presence :whatcd_score
      validates_presence :artist_id
      validates_presence :similar_artist_id
    end

  end
end
