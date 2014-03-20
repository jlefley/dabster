require 'ruby-progressbar'

class LibraryAlbumsScraper

  def initialize
    @album_scraper = LibraryAlbumScraper.new
  end

  def run(limit=nil)
    albums = Library::Album.unmatched(limit)
    unmatched = albums.length
    progress_bar = ProgressBar.create(format: 'Elapsed %a Remaining %E |%B| %p%%', starting_at: 0, total: unmatched)
    count = 0
    albums.each do |album|
      count += 1 if @album_scraper.fuzzy_match(album)
      progress_bar.increment
    end
    puts "Matched #{count} out of #{unmatched} album(s)"
  end

end
