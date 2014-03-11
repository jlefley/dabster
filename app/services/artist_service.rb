class ArtistService

  attr_reader :artist_class

  def initialize artist
    @artist_class = artist
  end

  def associate_artists group
    group.what_artists.each do |artist|
      what_id = artist.fetch(:id)
      what_name = artist.fetch(:name)

      if (artist = artist_class.first(what_id: what_id)).nil?
        artist = artist_class.new
        artist.what_id = what_id
        artist.what_name = what_name
        artist.save
      end

      group.add_artist(artist)
    end
    group
  end

end
