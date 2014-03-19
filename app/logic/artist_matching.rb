module ArtistMatching

  def match_artists
    associated_artists = artists
    relationship_types = associated_artists.map { |k, v| k }
    library_items.each do |item|
      existing_artists = item.artists
      relationship_types.each do |type|
        associated_artists[type].each do |artist|
          next if existing_artists[type] && existing_artists[type].include?(artist)
          item.add_artist(artist, type) if match?(item, artist)
        end
      end
    end
  end

  def match_implicit_artist
    library_items.each do |item|
      item_artists = item.artists
      next if item_artists[what_artist_type] && item_artists[what_artist_type].include?(what_artist)
      item.add_artist(what_artist, what_artist_type)
    end
  end

  def unmatch_implicit_artist
    library_items.each do |item|
      item.artists.each do |type, artists|
        artists.each do |artist|
          item.remove_artist(artist, type) if !match?(item, artist)
        end
      end
    end
  end

  private

  def match?(item, artist)
    item.artist.strip.downcase.include?(artist.what_name.strip.downcase)
  end

end
