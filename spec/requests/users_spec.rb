require 'rails_helper'

RSpec.describe "Users", type: :request do
  

  describe "GET /signup" do
    before :each do
      get "/signup"
    end 
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders home template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST /users" do
    context 'with valid params' do
      before :each do
        user_valid_params = { name: 'Valid_user', email: 'mail@valid.user', 
                            password: 'password', password_confirmation: 'password' }
        post "/users", params: { user: user_valid_params }
      end 
      it "returns http status 302" do
        expect(response.status).to eq(302)
      end
      it "redirects to new user show page" do
        expect(response).to redirect_to(user_url(User.find_by(name: 'Valid_user')))
      end
      it 'adds user to database' do
        count = User.count
        another_valid_params = { name: 'Another_user', email: 'mail@another.user', 
                            password: 'password', password_confirmation: 'password' }
        post "/users", params: { user: another_valid_params }
        expect(User.count).to eq(count + 1)
      end
    end
    context 'with invalid params' do
      before :each do
        user_invalid_params = { name: 'Invalid_user', email: 'mail@valid.user', 
                            password: 'password', password_confirmation: '' }
        post "/users", params: { user: user_invalid_params }
      end 
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "renders new user template" do
        expect(response).to render_template(:new)
      end
      it 'does not add user to database' do
        count = User.count
        another_invalid_params = { name: 'Another_invalid_user', email: '', 
                            password: 'password', password_confirmation: 'password' }
        post "/users", params: { user: another_invalid_params }
        expect(User.count).to eq(count)
      end
    end
  end

  describe "GET /users/:id" do
    let(:user) { FactoryBot.create(:user) }
    before :each do
      get "/users/#{user.id}"
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders show user template" do
        expect(response).to render_template(:show)
    end
  end

  describe "GET /users/:id/edit" do
    let(:user) { FactoryBot.create(:user) }
    before :each do
      get "/users/#{user.id}/edit"
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders edit user template" do
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH /users/:id/edit" do
    let(:user) { FactoryBot.create(:user) }
    context 'with valid params' do
      before :each do
        new_params = { name: 'New_name', email: 'new@user.mail', 
                            password: 'password', password_confirmation: 'password' }
        patch "/users/#{user.id}", params: { user: new_params }
      end 
      it "returns http status 302" do
        expect(response.status).to eq(302)
      end
      it "redirects to user show page" do
        expect(response).to redirect_to(user_url(user.id))
      end
    end
    context 'with invalid params' do
      before :each do
        new_invalid_params = { name: '', email: 'new@user.mail', 
                            password: 'password', password_confirmation: 'password' }
        patch "/users/#{user.id}", params: { user: new_invalid_params }
      end 
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "renders edit user template" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /users/:id" do
    let!(:user) { FactoryBot.create(:user) }
    it "returns http status 302" do
      delete "/users/#{user.id}"
      expect(response.status).to eq(302)
    end
    it "removes user from database" do
      count = User.count
      delete "/users/#{user.id}"
      expect(User.count).to eq(count - 1)
    end
  end
end
