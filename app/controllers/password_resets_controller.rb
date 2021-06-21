class PasswordResetsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:reset][:email])
    if user
      user.set_reset_digest
      user.send_reset_email
      flash[:info] = 'Password reset link has been sent'
      redirect_to root_url
    else
      flash[:danger] = 'This email address could not be found'
      render :new
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
    redirect_to root_url unless @user
  end

  def update
    @user = User.find_by(email: params[:email])
    if @user&.authenticated?(:reset, params[:id])
      if @user.reset_sent_at > (Time.zone.now - 1.hour)
        if @user.update(reset_params)
          flash[:success] = 'Your password has been reset'
          @user.delete_reset_digest
          login(@user)
          redirect_to user_url(@user)
        else
          render :edit
        end
      else
        flash[:danger] = 'Password reset link has expired'
        redirect_to login_url
      end
    else
      redirect_to root_url
    end
  end

  private

  def reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
