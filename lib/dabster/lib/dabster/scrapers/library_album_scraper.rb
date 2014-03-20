require 'fuzzy_match'

class LibraryAlbumScraper

  def initialize
    @what_scraper = WhatScraper.new(WhatAPIConnection.new, WhatGroup, WhatAPICache)
    @group_service = GroupService.new(Group)
    @artist_service = ArtistService.new(Artist)
  end

  def fuzzy_match(album)
    # Get results using library_album fields
    response = @what_scraper.scrape_results(groupname: album.album_only_letters, artistname: album.albumartist_only_letters)

    # Find matching group
    fz = FuzzyMatch.new(response.groups, read: :name)
    match = fz.find(album.album)

    # Return if match is not found
    return false if match.nil?

    # Scrape additional fields from what API
    result_group = @what_scraper.scrape_group(match.marshal_dump)

    # Determine confidence using similarity
    confidence = match.similarity(name: album.album, artist: album.albumartist) / 100

    # Associate with group and artists
    Sequel::Model.db.transaction do
      group = @group_service.associate_group(result_group, album, confidence)
      @artist_service.associate_artists(group)
    end
    true
  rescue StandardError => e
    File.open('scraper_log', 'a') do |file|
      file.puts "#{e.class} (#{e.message})"
      file.puts e.backtrace.join("\n")
      file.write "\n"
    end
    false
  end

end
