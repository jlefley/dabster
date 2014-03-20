require 'json'

class WhatAPIResultGroup < Sequel::Model
  serialize_attributes :json, :response
end
