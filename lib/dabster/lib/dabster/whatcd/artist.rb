require 'ostruct'

module Whatcd
  class Artist < OpenStruct
    def self.find(filter)
      Whatcd::ArtistSource.new(Whatcd::APIConnection.new, Whatcd::APICache, self).find(filter)
    end
  end
end
