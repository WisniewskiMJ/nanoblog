module SessionsHelper

  def current_user 
    # if session[:user_id] exists assign user_id variable to it
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # same as above but with cookies
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login(user)
        @current_user = user
      end
    end
  end

  def login(user)
    session[:user_id] = user.id
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
    user.set_remember_digest
    cookies.permanent[:remember_token] = user.remember_token
    cookies.permanent.encrypted[:user_id] = user.id
  end

  def forget(user)
    user.delete_remember_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
