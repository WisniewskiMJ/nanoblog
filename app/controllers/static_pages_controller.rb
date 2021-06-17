class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build 
      @pagy, @feed_items = pagy(current_user.feed, items: 20)
      render :layout => 'columns'
    end
  end

  def about
  end

  def contact
  end
end
