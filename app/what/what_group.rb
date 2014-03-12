require 'htmlentities'
require 'ostruct'

class WhatGroup < OpenStruct

  def initialize hash
    super(hash)
    @coder = HTMLEntities.new
  end

  def method_missing method, *args
    raise KeyError, "#{method} not set" unless respond_to?(method)
    super
  end
  
  def artist
    @coder.decode(super)
  end

  def groupName
    @coder.decode(super)
  end

  def id
    groupId
  end

  def map mapping
    Hash[mapping.map { |k, v| [v, self.send(k)] }]
  end

  def artists_hashes
    torrents.map { |t| t.fetch(:artists) }.flatten.uniq
  end

  def artists
    artists_hashes.map { |a| OpenStruct.new a }
  end

end
