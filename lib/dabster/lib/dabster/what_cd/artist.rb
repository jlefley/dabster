require 'ostruct'

module WhatCD
  class Artist < OpenStruct
    def self.find(filter)
      WhatCD::ArtistSource.new(WhatCD::APIConnection.new, WhatCD::APICache, self).find(filter)
    end
  end
end
