class WhatController < ApplicationController

  before_filter :connect_what_api

  def request_artist
    puts @api.make_request(action: 'artist', artistname: params[:artistname])
    render nothing: true
  end

  private

  def connect_what_api
    @api = WhatAPIConnection.new
  end

end
