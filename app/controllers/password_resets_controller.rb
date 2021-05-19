class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:reset][:email])
    if @user
      flash[:info] = 'Password reset link has been sent'
      redirect_to root_url
    else
      flash[:danger] = 'This email address could not be found'
      render 'new'
    end
  end

  def edit
  end

  def update
  end
end
