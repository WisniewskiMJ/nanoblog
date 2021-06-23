class StaticPagesController < ApplicationController
  layout 'columns', except: %i[about contact]
  before_action :require_logged_in, only: [:all_posts]

  def home
    if logged_in?
      @post = current_user.posts.build
      @pagy, @feed_items = pagy(current_user.feed, items: 20)
      render :home
    else
      render :welcome
    end
  end

  def all_posts
    @pagy, @all_items = pagy(posts_all, items: 20)
  end

  def about; end

  def contact; end
end
