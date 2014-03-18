require 'htmlentities'
require 'ostruct'

class WhatGroup < OpenStruct

  ARTISTS_MAPPING = {
    # what.cd API field => app field
    composers: :composer,
    dj:        :dj,
    artists:   :artist,
    with:      :with,
    conductor: :conductor,
    remixedBy: :remixed_by,
    producer:  :producer
  }  

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
    Hash[ARTISTS_MAPPING.map { |old_key, new_key| [new_key, musicInfo[old_key]] }]
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
