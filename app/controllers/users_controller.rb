class UsersController < ApplicationController
before_action :require_not_logged_in, only: [:new, :create]
before_action :require_logged_in, only: [:show]
before_action :require_owner, only: [:edit, :update]
before_action :require_owner_or_admin , only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_url(@user)
    else
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      render :edit
    end
  end
   
  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to root_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
