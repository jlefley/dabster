class ArtistService

  attr_reader :artist_class

  def initialize artist
    @artist_class = artist
  end

  def associate_artists group
    metadata_artists = group.what_artists.map do |artist|
      what_id = artist.fetch(:id)
      what_name = artist.fetch(:name)

      if (artist = artist_class.first(what_id: what_id)).nil?
        artist = artist_class.new
        artist.what_id = what_id
        artist.what_name = what_name
        artist.save
      end

      artist
    end
 
    existing_artists = group.artists
    added_artists = difference(metadata_artists, existing_artists)
    removed_artists = difference(existing_artists, metadata_artists)

    added_artists.each do |artist|
      group.add_artist(artist)
    end

    removed_artists.each do |artist|
      group.remove_artist(artist)
      artist.delete if artist.groups.empty?
    end

    group
  end

  private

  def difference a, b
    ids = b.map { |e| e.id }
    a.select { |e| !ids.include?(e.id) }
  end
  
end
