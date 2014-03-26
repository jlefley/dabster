require 'json'

module Whatcd
  class SimilarArtistsSource

    attr_reader :api, :api_cache, :similar_artists_class

    def initialize(api, api_cache, similar_artists_class)
      @api, @api_cache, @similar_artists_class = api, api_cache, similar_artists_class
    end

    def find(filter)
      raise(ArgumentError, 'id key required') unless filter.key?(:id)
      if !relationships = api_cache.similar_artists(filter)
        relationships = api.make_request(filter.merge(action: 'similar_artists', limit: 1000000))
        api_cache.cache_similar_artists(id: filter[:id], response: relationships)
      end
      relationships.map { |r| similar_artists_class.new(r) }
    rescue JSON::ParserError
      []
    end

  end
end
