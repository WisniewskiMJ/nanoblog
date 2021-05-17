require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  

  describe "GET #new" do
    let(:action) { :new }
    it_behaves_like 'an action requiring no logged in user', :new do
      let(:parameters) { nil }
    end
    before :each do
      call_action(action)
    end 
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders home template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    let(:action) { :create }
    it_behaves_like 'an action requiring no logged in user', :new do
      let(:parameters) { { user: { name: 'Valid_user', email: 'mail@valid.user', 
                         password: 'password', password_confirmation: 'password' } } }
    end
    context 'with valid params' do
      before :each do
        user_valid_params = { name: 'Valid_user', email: 'mail@valid.user', 
                            password: 'password', password_confirmation: 'password' }
        post :create, params: { user: user_valid_params }
      end 
      it "returns http status 302" do
        expect(response.status).to eq(302)
      end
      it "sends activation email" do
        logout
        email_count = ActionMailer::Base.deliveries.count
        other_valid_params = { name: 'Other_user', email: 'mail@other.user', 
                            password: 'password', password_confirmation: 'password' }
        post :create, params: { user: other_valid_params }
        expect(ActionMailer::Base.deliveries.count).to eq(email_count + 1)
      end
      it "displays activation email info message" do
        expect(flash[:info]).to eq('Check your email for account activation message')
      end
      it "redirects to home page" do
        expect(response).to redirect_to(root_url)
      end
      it 'adds user to database' do
        logout
        count = User.count
        another_valid_params = { name: 'Another_user', email: 'mail@another.user', 
                            password: 'password', password_confirmation: 'password' }
        post :create, params: { user: another_valid_params }
        expect(User.count).to eq(count + 1)
      end
    end
    context 'with invalid params' do
      before :each do
        user_invalid_params = { name: 'Invalid_user', email: 'mail@valid.user', 
                            password: 'password', password_confirmation: '' }
        post :create, params: { user: user_invalid_params }
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
        post :create, params: { user: another_invalid_params }
        expect(User.count).to eq(count)
      end
    end
  end

  describe "GET #show" do
    let(:user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring logged in user', :show do
    let(:parameters) { { id: user.id } }
    end
    before :each do
      login(user)
      get :show, params: { id: user.id }
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders show user template" do
        expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    let(:user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring owner logged in', :edit do
      let(:owner) { FactoryBot.create(:user) }
      let(:parameters) { { id: owner.id} }
      end
    it "returns http success" do
      login(user)
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
    it "renders edit user template" do
      login(user)
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    let(:user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring owner logged in', :update do
      let(:owner) { FactoryBot.create(:user) }
      let(:parameters) { { id: owner.id, user: { name: 'New_name', email: 'new@user.mail', 
                           password: 'password', password_confirmation: 'password' } } }
    end
    context 'with valid params' do
      before :each do
        login(user)
        new_params = { name: 'New_name', email: 'new@user.mail', 
                            password: 'password', password_confirmation: 'password' }
        patch :update, params: { id: user.id, user: new_params }
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
        login(user)
        new_invalid_params = { name: '', email: 'new@user.mail', 
                            password: 'password', password_confirmation: 'password' }
        patch :update, params: { id: user.id, user: new_invalid_params }
      end 
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "renders edit user template" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { FactoryBot.create(:user) }
    it_behaves_like 'an action requiring owner or admin logged in', :destroy do
      let(:parameters) { { id: user.id} }
      let(:owner) { FactoryBot.create(:user) }
      let(:owner_parameters) { { id: owner.id} }
    end
    it "returns http status 302" do
      login(user)
      delete :destroy, params: { id: user.id }
      expect(response.status).to eq(302)
    end
    it "removes user from database" do
      login(user)
      count = User.count
      delete :destroy, params: { id: user.id }
      expect(User.count).to eq(count - 1)
    end
  end
end
