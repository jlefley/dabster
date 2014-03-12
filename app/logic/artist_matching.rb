module ArtistMatching

  def match_artists
    library_items.each do |item|
      existing_artists = item.artists
      artists.each do |artist|
        next if existing_artists.include?(artist)
        item.add_artist(artist) if item.artist.strip.downcase.include?(artist.what_name.strip.downcase)
      end
    end
  end

end
