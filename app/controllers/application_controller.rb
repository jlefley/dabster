class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from StandardError, with: :show_error

  private

  def make_what_request
    api = WhatAPIConnection.new
    @what_response_hash = api.make_request(params[:what_request].to_query)
    @what_request = OpenStruct.new(params[:what_request])
    @what_response = RecursiveOpenStruct.new(@what_response_hash, recurse_over_arrays: true)
  end

  def show_error e
    flash[:error] = e.message
    redirect_to :back
  end
end
