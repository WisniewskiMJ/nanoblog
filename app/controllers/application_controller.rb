class ApplicationController < ActionController::Base

  def login(user)
    session[:user_id] = user.id
  end

  def current_user 
    # if session[:user_id] exists assign user_id variable to it
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # same as above but with cookies
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def remember(user)
    user.set_remember_token
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.encrypted[:user_id] = user.id
  end

  def forget(user)
    user.delete_remember_token
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def require_not_logged_in
    redirect_to root_url if logged_in?
  end

  def require_logged_in
    redirect_to root_url if !logged_in?
  end

  def require_owner
    @user = User.find_by(params[:id])
    redirect_to root_url if !logged_in? || @user != current_user 
  end
  
  def require_admin
    @user = User.find_by(params[:id])
    redirect_to root_url if !@user.admin?
  end
end