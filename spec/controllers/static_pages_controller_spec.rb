require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    context 'user is logged in' do
      let(:user) { FactoryBot.create(:user) }
      before :each do
        login(user)
        get :home
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders home template' do
        expect(response).to render_template(:home)
      end
    end
    context 'no user is logged in' do
      before :each do
        get :home
      end
      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders home template' do
        expect(response).to render_template(:welcome)
      end
    end
  end

  describe 'GET #all_posts' do
    let(:user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring logged in user', :all_posts do
      let(:parameters) { { id: user.id } }
    end
    before :each do
      login(user)
      get :all_posts
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'renders contact template' do
      expect(response).to render_template(:all_posts)
    end
  end

  describe 'GET #about' do
    before :each do
      get :about
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'renders contact template' do
      expect(response).to render_template(:about)
    end
  end

  describe 'GET #contact' do
    before :each do
      get :contact
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
    it 'renders contact template' do
      expect(response).to render_template(:contact)
    end
  end
end
