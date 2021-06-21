# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'default scope' do
    let!(:first_post) { FactoryBot.create(:post) }
    let!(:second_post) { FactoryBot.create(:post) }
    it 'orders posts by creation date descending' do
      posts = []
      Post.all.each { |post| posts << post }
      expect(posts).to eq([second_post, first_post])
    end
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(150) }
  end
end
