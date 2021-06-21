module UsersHelper
  def feed(user)
    Post.where('user_id == ?', user.id)
  end
end
