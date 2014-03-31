module Dabster
  class ApplicationController < ActionController::Base
    rescue_from DabsterApp::Error, with: :handle_error

    private
    
    def page
      (params[:page] || 1).to_i
    end

    def handle_error e
      logger.error
      logger.error e.message
      Rails.backtrace_cleaner.clean(e.backtrace).each { |line| logger.error '  ' + line }
      logger.error
      flash[:error] = e.message.truncate(400)
      redirect_to :back
    end
  end
end
