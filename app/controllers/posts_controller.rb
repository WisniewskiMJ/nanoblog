class PostsController < ApplicationController
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url
    else 
      flash[:danger] =  @post.errors.full_messages.to_sentence
      redirect_to root_url
    end
  end

  def destroy
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
end
