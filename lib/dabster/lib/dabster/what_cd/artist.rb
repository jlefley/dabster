require 'ostruct'

module WhatCD
  class Artist < OpenStruct
    def self.find(filter)
      ArtistSource.new(APIConnection.new, APICache, self).find(filter)
    end
  end
end
