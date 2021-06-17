class RelationshipsController < ApplicationController

  def create
    @user = User.find_by(id: params[:relationship][:followed_id])
    @relationship = Relationship.new(relationship_params)
    if @relationship.save
      flash[:success] = "You are now following #{@user.name}"
      redirect_to user_url(@user)
    else 
      flash[:danger] = 'You did not follow this user'
      redirect_to user_url(@user)
    end
  end 

  def destroy
    @relationship = Relationship.find_by(id: params[:id])
    @relationship.destroy
    redirect_to root_url
  end

  private

    def relationship_params
      params.require(:relationship)
            .permit(:follower_id, :followed_id)
            .with_defaults(follower_id: current_user.id)
    end
end
