class UsersController < ApplicationController
  layout 'columns', except: [:inactive]

  before_action :require_not_logged_in, only: %i[new create inactive resend_activation]
  before_action :require_logged_in, only: %i[show following followers]
  before_action :require_owner, only: %i[edit update]
  before_action :require_owner_or_admin, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Account activation email has been sent'
      redirect_to inactive_user_url(@user)
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
    @title = "#{@user.name} is following:"
    @related = @user.following
    render :show_follow
  end

  def followers
    @user = User.find_by(id: params[:id])
    @title = "#{@user.name}'s followers:"
    @related = @user.followers
    render :show_follow
  end

  def inactive
    @user = User.find_by(id: params[:id])
  end

  def resend_activation
    @user = User.find_by(id: params[:id])
    @user.new_activation_digest
    @user.send_activation_email
    flash[:info] = 'Account activation email has been sent'
    redirect_to inactive_user_url(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :background_image)
  end
end
