class WhatAPICache

  def self.cache_result_group(fields)
    if group = WhatAPIResultGroup.first(group_id: fields.fetch(:group_id))
      group.update(response: fields.fetch(:response))
    else
      WhatAPIResultGroup.create(fields)
    end
  end

  def self.cache_torrent_group(fields)
    if group = WhatAPITorrentGroup.first(group_id: fields.fetch(:group_id))
      group.update(response: fields.fetch(:response))
    else
      WhatAPITorrentGroup.create(fields)
    end
  end

  def self.torrent_group(filter)
    if group = WhatAPITorrentGroup.first(filter)
      group.response
    end
  end

end
