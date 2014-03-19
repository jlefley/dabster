require 'ostruct'

class WhatBrowseResponse < OpenStruct

  def groups
    results.map { |g| WhatGroup.new(g) }
  end

  def sort_groups(fields)
    groups.sort do |a, b|
      b.similarity(fields) <=> a.similarity(fields)
    end
  end

end
