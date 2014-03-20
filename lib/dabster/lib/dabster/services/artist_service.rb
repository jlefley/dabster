class ArtistService

  attr_reader :artist_class

  def initialize artist
    @artist_class = artist
  end

  def associate_artists group
    existing_artists = group.artists_by(:type)
   
    group.what_artists.each do |type, artists|
      metadata_artists = artists.map do |artist|
        what_id = artist.fetch(:id)
        what_name = artist.fetch(:name)

        if (artist = artist_class.first(what_id: what_id)).nil?
          artist = artist_class.new
          artist.what_id = what_id
          artist.what_name = what_name
          artist.what_updated_at = Time.now
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
