module Whatcd
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

    def similar_artists(filter)
      if cached = WhatcdSimilarArtistsResponse.first(filter)
        cached.response
      end
    end

    def cache_similar_artists(fields)
      if cached = WhatcdSimilarArtistsResponse.first(id: fields.fetch(:id))
        cached.update(response: fields.fetch(:response))
      else
        WhatcdSimilarArtistsResponse.create(fields)
      end
    end

  end
end
