class RelationshipsController < ApplicationController
  before_action :require_logged_in

  def create
    @followed = User.find_by(id: params[:relationship][:followed_id])
    @relationship = Relationship.new(follower_id: current_user.id, followed_id: @followed.id)
    if current_user != @followed
      if @relationship.save
        flash[:info] = "You are now following #{@followed.name}"
      else
        flash[:danger] = @relationship.errors.full_messages.to_sentence
      end
      redirect_to user_url(@followed)
    else
      flash[:danger] = 'You can not follow yourself'
      redirect_to root_url
    end
  end

  def destroy
    relationship = current_user.active_relationships.find_by(id: params[:id])
    if relationship
      relationship.destroy
      flash[:info] = 'You have unfollowed user'
    else
      flash[:danger] = 'You have not been following this user'
    end
    redirect_to root_url
  end
end
