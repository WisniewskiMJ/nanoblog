class PostsController < ApplicationController
  before_action :require_logged_in

  def create
    @post = current_user.posts.build(post_params)
    flash[:danger] = @post.errors.full_messages.to_sentence unless @post.save
    redirect_to root_url
  end

  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    if @post
      @post.destroy
      flash[:success] = 'Post has been deleted'
      redirect_to request.referer || root_url
    else
      flash[:danger] = 'You can not delete this post'
      redirect_to root_url
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
