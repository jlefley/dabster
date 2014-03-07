module ApplicationHelper

  def torrent_artists torrents
    torrents.map { |torrent| torrent.artists.map { |artist| OpenStruct.new(name: artist.name, id: artist.id) } }.flatten.uniq
  end

end
