require 'thor'

module Dabster
  class CLI < Thor

    desc 'stats', 'show stats'
    def stats
      puts "#{Library::Album.count} albums, #{Library::Album.matched.count} matched"
      puts "#{Library::Item.count} items"
      puts "#{Artist.count} artists"
    end

    desc 'update STATUS', 'updates STATUS library albums with metadata from whatcd'
    option :limit
    def update(match_status=nil)
      case match_status
      when 'all'
        scraper.all(options[:limit])
      when 'matched'
        scraper.matched(options[:limit])
      when 'unmatched'
        scraper.unmatched(options[:limit])
      else
        puts 'ERROR: match status must be all, matched, or unmatched'
        return
      end
    end

    private

    def scraper
      LibraryAlbumsScraper.new
    end

  end
end
