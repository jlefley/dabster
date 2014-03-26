require 'ostruct'

module Whatcd
  class SimilarArtists < OpenStruct

    def self.find(filter)
      Whatcd::SimilarArtistsSource.new(Whatcd::APIConnection.new, Whatcd::APICache, self).find(filter)
    end

  end
end
