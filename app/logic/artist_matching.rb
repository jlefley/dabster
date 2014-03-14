module ArtistMatching

  def match_artists
    associated_artists = artists
    relationship_types = associated_artists.map { |k, v| k }
    library_items.each do |item|
      existing_artists = item.artists
      relationship_types.each do |type|
        associated_artists[type].each do |artist|
          next if existing_artists[type].include?(artist)
          item.add_artist(artist, type) if item.artist.strip.downcase.include?(artist.what_name.strip.downcase)
        end
      end
    end
  end

end
