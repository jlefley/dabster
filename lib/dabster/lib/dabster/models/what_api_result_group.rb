require 'json'

class WhatAPIResultGroup < Sequel::Model
  plugin :timestamps, update_on_create: true
  serialize_attributes :json, :response
end
