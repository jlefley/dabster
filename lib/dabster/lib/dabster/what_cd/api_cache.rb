module WhatCD
  module APICache

    module_function
      
    def cache_torrent_group(fields)
      if cached = WhatcdTorrentGroupResponse.first(id: fields.fetch(:id))
        cached.update(response: fields.fetch(:response))
      else
        WhatcdTorrentGroupResponse.create(fields)
      end
    end

    def torrent_group(filter)
      if cached = WhatcdTorrentGroupResponse.first(filter)
        cached.response
      end
    end
  
    def cache_artist(fields)
      if cached = WhatcdArtistResponse.first(id: fields.fetch(:id))
        cached.update(response: fields.fetch(:response))
      else
        WhatcdArtistResponse.create(fields)
      end
    end

    def artist(filter)
      if cached = WhatcdArtistResponse.first(filter)
        cached.response
      end
    end

  end
end
