require 'ostruct'

module Whatcd
  class SimilarArtists

    def self.find(filter)
      Whatcd::SimilarArtistsSource.new(Whatcd::APIConnection.new, Whatcd::APICache, OpenStruct).find(filter)
    end

  end
end
