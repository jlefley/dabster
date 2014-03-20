class LibraryAlbumsScraper

  def initialize
    @album_scraper = LibraryAlbumScraper.new
  end

  def run(limit=nil)
    count = 0
    Library::Album.unmatched(limit).each do |album|
      count += 1 if @album_scraper.fuzzy_match(album)
    end
    count
  end

end
