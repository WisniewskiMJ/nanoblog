require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST#create' do
    let(:user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring logged in user', :create do
      let(:parameters) { { post: { content: Faker::Hipster.sentence } } }
    end
    context 'with valid params' do
      it 'adds post to database' do
        posts_count = Post.all.count
        login(user)
        post :create, params: { post: { content: Faker::Hipster.sentence } }
        expect(Post.all.count).to eq(posts_count + 1)
      end
      it 'redirects to home page' do
        login(user)
        post :create, params: { post: { content: Faker::Hipster.sentence } }
        expect(response).to redirect_to(root_url)
      end
    end
    context 'with invalid params' do
      before :each do
        login(user)
        post :create, params: { post: { content: nil } }
      end
      it 'displays errors messages' do
        expect(flash[:danger]).not_to be_nil
      end
      it 'redirects to home page' do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'DELETE#destroy' do
    it_behaves_like 'an action requiring logged in user', :destroy do
      let(:user) { FactoryBot.create(:user) }
      let(:post) { FactoryBot.create(:post, user_id: user.id) }
      let(:parameters) { { id: post.id } }
    end
    let(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post, user_id: user.id) }
    before :each do
      login(user)
    end
    context 'author of the post attempts delete' do
      it 'removes post from database' do
        post_count = Post.all.count
        delete :destroy, params: { id: post.id }
        expect(Post.all.count).to eq(post_count - 1)
      end
      it 'displays post deleted info message' do
        delete :destroy, params: { id: post.id }
        expect(flash[:success]).to eq('Post has been deleted')
      end
      it 'redirects to home page' do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(root_url)
      end
    end
    context 'other user attempts delete' do
      let(:another_user) { FactoryBot.create(:user) }
      before :each do
        login(another_user)
        delete :destroy, params: { id: post.id }
      end
      it 'displays warning message' do
        expect(flash[:danger]).to eq('You can not delete this post')
      end
      it 'redirects to home page' do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
