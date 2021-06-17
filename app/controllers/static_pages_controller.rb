class StaticPagesController < ApplicationController
  before_action :require_logged_in, only: [:all_posts]

  def home
    if logged_in?
      @post = current_user.posts.build 
      @pagy, @feed_items = pagy(current_user.feed, items: 20)
      render :layout => 'columns'
    end
  end

  def all_posts
    @pagy, @all_items = pagy(current_user.all_posts, items: 20)
    render :layout => 'columns'
  end

  def about
  end

  def contact
  end
end
