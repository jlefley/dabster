module Dabster
  module Whatcd
    class TorrentGroupSource

      attr_reader :api, :api_cache, :artist_source, :group_class, :results_class

      def initialize(api, api_cache, artist_source, group_class, results_class)
        @api, @api_cache, @artist_source, @group_class, @results_class = api, api_cache, artist_source, group_class, results_class
      end

      def find(filter)
        if (!filter.key?(:id) && !filter.key?(:hash)) || (filter.key?(:id) && filter.key?(:hash))
          raise(ArgumentError, 'requires either hash or id key') 
        end
        if filter.key?(:id) && torrent_group_response = api_cache.torrent_group(filter)
          torrent_group = torrent_group_response.fetch(:group)
        else
          torrent_group_response = api.make_request(filter.merge(action: 'torrentgroup'))
          torrent_group = torrent_group_response.fetch(:group)
          api_cache.cache_torrent_group(id: torrent_group[:id], response: torrent_group_response)
        end
        artist_id = torrent_group[:musicInfo].values.flatten.map { |a| a[:id] }.first
        raise(Error, 'torrent group does not have any artists') unless artist_id
        artist = artist_source.find(id: artist_id)
        artist_torrent_group = artist.torrentgroup.select { |g| g[:groupId] == torrent_group[:id] }.first
        raise(Error, 'artist does not contain matching torrent group') unless artist_torrent_group
        raise(Error, 'artist torrent group name does not match') unless artist_torrent_group[:groupName] == torrent_group[:name]
        group_class.new(torrent_group.merge(artist_torrent_group))
      end

      def search(filter)
        results_class.new(api.make_request(filter.merge(action: 'browse', 'filter_cat[1]' => 1)))
      end

    end
  end
end
