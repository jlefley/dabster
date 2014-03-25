require 'ostruct'

module Whatcd
  class TorrentGroupResults < OpenStruct

    def groups
      results.map { |g| TorrentGroup.new(g) }
    end

    def sort_groups(fields)
      groups.sort do |a, b|
        b.similarity(fields) <=> a.similarity(fields)
      end
    end

  end
end
