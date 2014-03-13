require 'htmlentities'
require 'ostruct'

class WhatGroup < OpenStruct

  def initialize hash
    super(hash)
    @coder = HTMLEntities.new
  end

  def id
    groupId || super
  end

  def name
    @coder.decode(groupName || super)
  end

  def artist
    @coder.decode(super)
  end

  def year
    groupYear || super
  end

  def release_type
    releaseType
  end

  def catalog_number
    catalogueNumber
  end

  def artists
    musicInfo
  end

  def record_label
    recordLabel
  end

  def map mapping
    Hash[mapping.map { |old_key, new_key| raise(KeyError, "#{old_key} missing") unless val = send(old_key); [new_key, val] }]
  end

  def torrent_artists
    torrents.map { |t| t.fetch(:artists) }.flatten.uniq.map { |a| OpenStruct.new(a) }
  end

end
