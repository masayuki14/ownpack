class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_user

  def set_current_user
    return if session[:user_id].blank?
    session[:user] ||= User.find(session[:user_id])
    @current_user = session[:user]
  end
end
