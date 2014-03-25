module ArtistMatching

  def match_artists
    associated_artists = artists_by(:type)
    relationship_types = associated_artists.map { |k, v| k }
    library_items.each do |item|
      existing_artists = item.artists_by(:type)
      relationship_types.each do |type|
        associated_artists[type].each do |artist|
          next if existing_artists[type] && existing_artists[type].include?(artist)
          item.add_artist(artist, type: type, group_artist: false, confidence: 0.99) if match?(item, artist)
        end
      end
    end
  end

  private

  def match?(item, artist)
    item.artist.strip.downcase.include?(artist.whatcd_name.strip.downcase)
  end

end
