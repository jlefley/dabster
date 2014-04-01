module Dabster
  class CLI < Thor

    desc 'stats', 'show stats'
    def stats
      puts "#{Library::Album.count} albums, #{Library::Album.matched.count} matched"
      puts "#{Library::Item.count} items"
      puts "#{Artist.count} artists"
    end

    desc 'update TYPE', 'updates entities of type TYPE with metadata from whatcd'
    option :limit
    def update(type=nil)
      case type
      when 'album'
        album_scraper.matched(options[:limit])
      when 'similarartists'
        similar_artists_scraper.all(options[:limit])
      when 'all'
        album_scraper.matched(options[:limit])
        artists_scraper.similar_artists(options[:limit])
      else
        puts 'ERROR: TYPE must be album, similarartists, or all'
        return
      end
    end

    desc 'match', 'match albums with metadata from whatcd'
    option :limit
    def match
      album_scraper.unmatched(options[:limit])
    end
    
    private

    def album_scraper
      LibraryAlbumsScraper.new
    end

    def similar_artists_scraper
      SimilarArtistsScraper.new
    end

  end
end
