class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Dabster::Error, with: :show_error

  private

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
