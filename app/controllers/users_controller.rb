class UsersController < ApplicationController
layout 'columns'

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
      @user.send_activation_email
      flash[:info] = 'Check your email for account activation message'
      redirect_to root_url 
    else
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    puts user_params
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      puts @user.errors.full_messages.to_sentence
      render :edit
    end
  end
   
  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    redirect_to root_url
  end

  def following
    @user = User.find_by(id: params[:id])
    @title = @user.name + ' is following:'
    @related = @user.following
    render :show_follow
  end

  def followers
    @user = User.find_by(id: params[:id])
    @title = @user.name + '\'s followers:'
    @related = @user.followers
    render :show_follow
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :background_image)
    end
  
end
