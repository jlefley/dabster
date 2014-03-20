require 'json'

class WhatAPITorrentGroup < Sequel::Model
  serialize_attributes :json, :response
end
