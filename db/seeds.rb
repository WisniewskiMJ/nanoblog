require 'faker'
require 'factory_bot_rails'

User.destroy_all

15.times do
  FactoryBot.create(:user)
end

User.all.each { |user| user.activate! }

5.times do
  User.all.each do |user|
    rand(0..3).times do
      FactoryBot.create(:post, user_id: user.id)
    end
  end
end