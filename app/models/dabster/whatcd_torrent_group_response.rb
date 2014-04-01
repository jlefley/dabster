module Dabster
  class WhatcdTorrentGroupResponse < Sequel::Model
    unrestrict_primary_key
    plugin :timestamps, update_on_create: true
    serialize_attributes :json, :response
  end
end
