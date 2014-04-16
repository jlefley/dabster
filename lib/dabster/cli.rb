require 'thor'

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

    desc 'server ARTIST_WHATCD_ID', 'start playback proxy server for specified artist and XMMS_HOST, can specify playlist_id to use existing playlist'
    option :playlist_id
    def server(artist_whatcd_id)

      if playlist_id = options[:playlist_id]
        plist = Playlist.first!(id: playlist_id)
      else
        plist = Playlist.create(initial_artist: Artist.first!(whatcd_id: artist_whatcd_id))
      end

      puts "Playlist: #{plist.inspect}"
      puts "Artist: #{plist.initial_artist.inspect}"

      PlaybackServer.new(Playlists::ArtistGraphBreadthDynamicPlaylist.new(p, Recommenders::PlayAll.new)).run
    end
    
    private

    def album_scraper
      Scrapers::LibraryAlbumsScraper.new
    end

    def similar_artists_scraper
      Scrapers::SimilarArtistsScraper.new
    end

  end
end
