class WhatController < ApplicationController

  before_filter :connect_what_api
  layout false

  def make_request
    @response = @api.make_request(params[:request])
    render json: @response
  end

  private

  def connect_what_api
    @api = WhatAPIConnection.new
  end

  def template
    params[:request][:action]
  end

end
