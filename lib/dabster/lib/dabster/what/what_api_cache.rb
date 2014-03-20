class WhatAPICache

  def self.cache_result_group(fields)
    WhatAPIResultGroup.create(fields)
  end

  def self.cache_torrent_group(fields)
    WhatAPITorrentGroup.create(fields)
  end

end
