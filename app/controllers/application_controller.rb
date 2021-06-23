class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  include ActionView::Helpers::TextHelper

  def require_not_logged_in
    return unless logged_in?

    flash[:danger] = 'You can not perform this action while logged in'
    redirect_to root_url
  end

  def require_logged_in
    return if logged_in?

    flash[:danger] = 'You have to be logged in to perform this action'
    redirect_to root_url
  end

  def require_owner
    if !logged_in?
      require_logged_in
    else
      user = User.find_by(id: params[:id])
      if user != current_user
        flash[:danger] = 'Only owner of the account can perform this action'
        redirect_to root_url
      end
    end
  end

  def require_admin
    user = User.find_by(id: params[:id])
    redirect_to root_url unless user.admin?
  end

  def require_owner_or_admin
    user = User.find_by(id: params[:id])
    require_owner unless user.admin?
  end

  def posts_all
    Post.all
  end
end
