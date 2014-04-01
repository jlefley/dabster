require 'fuzzy_match'

module Dabster
  class LibraryAlbumScraper

    def initialize
      @group_service = GroupService.new(Group)
      @artist_service = ArtistService.new(Artist)
    end

    def fuzzy_match(album)

      # Go through matching strategies and return false if no match found
      matching =
        va_exact(album) || 
        va_only_letters(album) ||
        exact(album) ||
        letters_only_groupname(album) ||
        letters_only_both(album)

      return false if matching.nil?

      # Find the group
      torrent_group = Whatcd::TorrentGroup.find(id: matching.id)

      # Determine confidence using similarity
      confidence = matching.similarity(name: album.album, artist: album.albumartist) / 100

      # Associate with group and artists
      Sequel::Model.db.transaction do
        group = @group_service.associate_group(torrent_group, album, confidence)
        @artist_service.associate_artists(group)
      end

      true
    rescue StandardError => e
      log_exception(e, album, torrent_group) 
      false
    end

    def id_match(album, torrent_group_id, confidence)
      torrent_group = Whatcd::TorrentGroup.find(id: torrent_group_id)
      
      Sequel::Model.db.transaction do
        group = @group_service.associate_group(torrent_group, album, confidence)
        @artist_service.associate_artists(group)
      end

      true
    rescue StandardError => e
      log_exception(e, album, torrent_group) 
      false
    end

    def hash_match(album, hash)
      torrent_group = Whatcd::TorrentGroup.find(hash: hash)
      
      confidence = torrent_group.similarity(name: album.album) / 100
      
      Sequel::Model.db.transaction do
        group = @group_service.associate_group(torrent_group, album, confidence)
        @artist_service.associate_artists(group)
      end

      true
    rescue StandardError => e
      log_exception(e, album, torrent_group) 
      false
    end

    private

    def log_exception(e, album, torrent_group)
      msg = []
      msg << "#{e.class} (#{e.message})"
      msg << "Library album: #{album.inspect}"
      msg << "Torrent group: #{torrent_group.inspect}"
      msg += e.backtrace
      Dabster.log(:error, msg.join("\n"))
    end

    def va_only_letters(album)
      return unless album.albumartist.downcase == 'various artists'
      response = search(groupname: album.album_only_letters)
      match(response.groups.select { |g| g.artist.downcase == 'various artists' }, album.album)
    end

    def va_exact(album)
      return unless album.albumartist.downcase == 'various artists'
      response = search(groupname: album.album)
      match(response.groups.select { |g| g.artist.downcase == 'various artists' }, album.album)
    end

    def letters_only_both(album)
      match(search(groupname: album.album_only_letters, artistname: album.albumartist_only_letters).groups, album.album)
    end

    def exact(album)
      match(search(groupname: album.album, artistname: album.albumartist).groups, album.album)
    end

    def letters_only_groupname(album)
      match(search(groupname: album.album_only_letters, artistname: album.albumartist).groups, album.album)
    end

    def search(filter)
      Whatcd::TorrentGroup.search(filter)
    end

    def match(groups, name)
      FuzzyMatch.new(groups, read: :name).find(name)
    end

  end
end
