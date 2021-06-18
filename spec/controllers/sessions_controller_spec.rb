require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  
  describe "GET #new" do
    let(:action) { :new }
    it_behaves_like 'an action requiring no logged in user', :new do
      let(:parameters) { nil }
    end
    it "returns http success" do
      call_action(action)
      expect(response).to have_http_status(:success)
    end
    it "renders login page" do
      call_action(action)
      expect(response).to render_template(:new)
    end   
  end

  describe "POST #create" do
    let(:action) { :create }
    let(:parameters) { { session: { email: user.email, password: 'password' } } }
    it_behaves_like 'an action requiring no logged in user', :create do
      let(:parameters) { { session: { email: user.email, password: 'password' } } }
    end
    context "with valid params" do
      context "user account is activated" do
        before :each do
          user.update_attribute(:activated, true)
          valid_params = { session: { email: user.email, password: 'password' } }
          call_action(action, valid_params)
        end
        it "returns http status 302" do
          expect(response.status).to eq(302)
        end
        it "logs user in" do
          expect(is_logged_in?(user)).to be true
        end
        it "redirects to new user show page" do
          expect(response).to redirect_to(root_url)
        end
      end

      context "user account is not activated" do
         before :each do
          valid_params = { session: { email: user.email, password: 'password' } }
          call_action(action, valid_params)
        end
        it "returns http status 302" do
          expect(response.status).to eq(302)
        end
        it "does not log user in" do
          expect(is_logged_in?(user)).not_to be true
        end
        it "redirects to home page" do
          expect(response).to redirect_to(root_url)
        end
        it 'displays warning message' do
          expect(flash[:warning]).to eq('User account not activated. Check your email for activation link')
        end
      end
    end

    context "with invalid params" do
      before :each do
        invalid_params = { session: { email: user.email, password: 'pasword' } }
        call_action(action, invalid_params) 
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "does not log user in" do
        expect(is_logged_in?(user)).to_not be true
      end
      it "renders login page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:action) { :destroy }
    it_behaves_like 'an action requiring logged in user', :destroy do
    let(:parameters) { nil }
    end
    before :each do
      login(user)
      call_action(:destroy)
    end
    it "returns http status 302" do
      expect(response.status).to eq(302)
    end
    it "redirects to home page" do
        expect(response).to redirect_to(root_url)
    end
    it "logs user out" do
      expect(is_logged_in?(user)).to_not be true
    end
  end

end
