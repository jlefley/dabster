module ApplicationHelper

  def torrent_artists torrents
    torrents.map { |torrent| torrent.artists.map { |artist| OpenStruct.new(name: artist.name, id: artist.id) } }.flatten.uniq
  end

  def html_decode str
    @coder ||= HTMLEntities.new
    @coder.decode(str)
  end

  def format_date obj
    formatted = obj.year.to_s
    formatted << '-' << format('%02d', obj.month) if obj.month > 0
    formatted << '-' << format('%02d', obj.day) if obj.day > 0
    formatted
  end

end
