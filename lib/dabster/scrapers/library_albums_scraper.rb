require 'ruby-progressbar'

module Dabster
  module Scrapers
    class LibraryAlbumsScraper

      def initialize
        @album_scraper = Dabster::Scrapers::LibraryAlbumScraper.new
      end

      def unmatched(limit=nil)
        albums = Dabster::Library::Album.unmatched.limit(limit).all
        create_progress_bar(albums.length)
        update_albums(albums)
      end

      def matched(limit=nil)
        albums = Dabster::Library::Album.matched.limit(limit).all
        create_progress_bar(total = albums.length)
        update_albums(albums)
      end

      def all(limit=nil)
        albums = Dabster::Library::Album.limit(limit).all
        create_progress_bar(albums.length)
        update_albums(albums)
      end

      private

      def update_albums(albums)
        albums.each do |album|
          if group = album.group
            @count += 1 if @album_scraper.id_match(album, group.whatcd_id, group.whatcd_confidence)
          elsif hash = album.torrent_hash
            @count += 1 if @album_scraper.hash_match(album, hash)
          else
            @count += 1 if @album_scraper.fuzzy_match(album)
          end
          @progress_bar.increment
        end
        puts "Updated #{@count} out of #{@total} album(s)"
      end

      def create_progress_bar(total)
        @count = 0
        @total = total
        @progress_bar = ProgressBar.create(format: 'Elapsed %a Remaining %E |%B| %p%%', starting_at: 0, total: total)
      end

    end
  end
end
