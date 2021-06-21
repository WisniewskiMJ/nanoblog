require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  describe 'POST#create' do
    let(:user) { FactoryBot.create(:user) }
    let(:another_user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring logged in user', :create do
      let(:parameters) { { relationship: { followed_id: another_user.id } } }
    end
    before :each do
      login(user)
    end
    it 'adds another user to current user following ' do
      following_count = user.following.count
      post :create, params: { relationship: { followed_id: another_user.id } }
      expect(user.following.count).to eq(following_count + 1)
    end
    it 'displays info message' do
      post :create, params: { relationship: { followed_id: another_user.id } }
      expect(flash[:info]).to eq("You are now following #{another_user.name}")
    end
    it 'redirects to followed user show page' do
      post :create, params: { relationship: { followed_id: another_user.id } }
      expect(response).to redirect_to(user_url(another_user.id))
    end
  end

  describe 'DELETE#destroy' do
    it_behaves_like 'an action requiring logged in user', :destroy do
      let(:user) { FactoryBot.create(:user) }
      let(:another_user) { FactoryBot.create(:user) }
      let(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user.id) }
      let(:parameters) { { id: relationship.id } }
    end
    context 'user is following another user' do
      let(:user) { FactoryBot.create(:user) }
      let(:another_user) { FactoryBot.create(:user) }
      let!(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user.id) }
      before :each do
        login(user)
      end
      it 'removes another user from user following list' do
        following_count = user.following.count
        delete :destroy, params: { id: relationship.id }
        expect(user.following.count).to eq(following_count - 1)
      end
      it 'displays info message' do
        delete :destroy, params: { id: relationship.id }
        expect(flash[:info]).to eq('You have unfollowed user')
      end
      it 'redirects to home page' do
        delete :destroy, params: { id: relationship.id }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'user is not following another user' do
      let(:user) { FactoryBot.create(:user) }
      let(:another_user) { FactoryBot.create(:user) }
      let!(:relationship) { FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user.id) }
      before :each do
        login(another_user)
        delete :destroy, params: { id: relationship.id }
      end
      it 'displays warning message' do
        expect(flash[:danger]).to eq('You have not been following this user')
      end
      it 'redirects to home page' do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
