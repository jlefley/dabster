require 'json'

class WhatAPITorrentGroup < Sequel::Model
  plugin :timestamps, update_on_create: true
  serialize_attributes :json, :response
end
