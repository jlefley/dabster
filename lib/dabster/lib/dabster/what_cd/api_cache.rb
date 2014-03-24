module WhatCD
  module APICache

    module_function
      
    def cache_torrent_group(fields)
      if cached = WhatCDTorrentGroupResponse.first(id: fields.fetch(:id))
        cached.update(response: fields.fetch(:response))
      else
        WhatCDTorrentGroupResponse.create(fields)
      end
    end

    def torrent_group(filter)
      if cached = WhatCDTorrentGroupResponse.first(filter)
        cached.response
      end
    end
  
    def cache_artist(fields)
      if cached = WhatCDArtistResponse.first(id: fields.fetch(:id))
        cached.update(response: fields.fetch(:response))
      else
        WhatCDArtistResponse.create(fields)
      end
    end

    def artist(filter)
      if cached = WhatCDArtistResponse.first(filter)
        cached.response
      end
    end

  end
end
