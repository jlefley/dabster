require 'htmlentities'

class WhatGroup

  def initialize group
    @group = group
    @coder = HTMLEntities.new
  end

  def map mapping
    Hash[mapping.map { |k, v|
      [v, [:what_name, :what_artists].include?(k) ? @coder.decode(@group.fetch(k)) : @group.fetch(k)]
    }]
  end

  def artists
    @group.fetch(:torrents).map { |t| t.fetch(:artists) }.flatten.uniq
  end

  def id
    @group.fetch(:groupId)
  end

end
