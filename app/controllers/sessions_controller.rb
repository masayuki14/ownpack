class SessionsController < ApplicationController
  def callback
    #raise request.env['omniauth.auth'].to_yaml

    auth = request.env['omniauth.auth']
    logger.debug auth
    user = User.find_by_twitter_uid(auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to :controller => 'welcome', :action => 'index', :notice => 'login!'
  end

  def destroy
    session[:user_id] = nil
    redirect_to :controller => 'welcome', :action => 'index', :notice => 'logout!'
  end
end
