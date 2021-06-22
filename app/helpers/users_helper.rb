module UsersHelper
  def feed(user)
    following_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                OR user_id = :user_id", user_id: user.id)
  end
end
