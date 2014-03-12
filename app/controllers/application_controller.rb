class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Dabster::Error, with: :show_error

  private

  def make_what_request
    response_hash = WhatAPIConnection.new.make_request(params[:what_request].to_query)
    @what_request = OpenStruct.new(params[:what_request])
    
    case @what_request.action
    when 'browse'
      results = response_hash.fetch(:results)
      @what_response = OpenStruct.new(response_hash.merge(groups: results.map { |r| WhatGroup.new r }))
    else
      @what_response = RecursiveOpenStruct.new(response_hash, recurse_over_arrays: true)
    end
  end

  def show_error e
    msg = e.message
    if match = msg.match(/(.+missing field in hash: \W\S+)/)
      msg = match[1] 
    end
    logger.error
    logger.error msg
    Rails.backtrace_cleaner.clean(e.backtrace).each { |line| logger.error '  ' + line }
    logger.error
    flash[:error] = msg
    redirect_to :back
  end
end
