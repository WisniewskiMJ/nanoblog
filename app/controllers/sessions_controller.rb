class SessionsController < ApplicationController
  before_action :require_not_logged_in, only: [:new, :create]
  before_action :require_logged_in, only: [:destroy]
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      else
        redirect_to inactive_user_url(user)
      end
    else
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
