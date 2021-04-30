class SessionsController < ApplicationController
  include SessionsHelper
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      login(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user_url(user)
    else
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end
end
