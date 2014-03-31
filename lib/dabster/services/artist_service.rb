module Dabster
  module Services
    class ArtistService

      attr_reader :artist_class

      def initialize artist
        @artist_class = artist
      end

      def associate_artists group
        existing_artists = group.artists_by(:type)
       
        group.whatcd_artists.each do |type, artists|
          metadata_artists = artists.map do |artist|
            whatcd_id = artist.fetch(:id)
            whatcd_name = artist.fetch(:name)

            if (artist = artist_class.first(whatcd_id: whatcd_id)).nil?
              artist = artist_class.new
              artist.whatcd_id = whatcd_id
              artist.whatcd_name = whatcd_name
              artist.whatcd_updated_at = Time.now
              artist.save
            end

            artist
          end
     
          existing_type_artists = existing_artists[type] || []

          added_artists = difference(metadata_artists, existing_type_artists)
          removed_artists = difference(existing_type_artists, metadata_artists)

          added_artists.each do |artist|
            group.add_artist(artist, type: type)
          end

          removed_artists.each do |artist|
            group.remove_artist(artist, type: type)
          end
        end
       
        group.remove_group_artists_from_items
        group.match_artists
        group.add_group_artists_to_items
        group
      end

      private

      def difference a, b
        ids = b.map { |e| e.id }
        a.select { |e| !ids.include?(e.id) }
      end
      
    end
  end
end
