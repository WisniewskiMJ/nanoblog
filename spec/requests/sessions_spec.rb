require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { FactoryBot.create(:user) }
  
  describe "GET /login" do
    before :each do
      get "/login"
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders login page" do
      expect(response).to render_template(:new)
    end   
  end

  describe "POST /login" do
    context "with valid params" do
      before :each do
        valid_params = { email: user.email, password: 'password' }
        post "/login", params: { session: valid_params }
      end
      it "returns http status 302" do
        expect(response.status).to eq(302)
      end
      it "logs user in" do
        expect(is_logged_in?(user)).to be true
      end
      it "redirects to new user show page" do
        expect(response).to redirect_to(user_url(user))
      end
    end

    context "with invalid params" do
      before :each do
        invalid_params = { email: user.email, password: 'pasword' }
        post "/login", params: { session: invalid_params }
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

  describe "DELETE /logout" do
    before :each do
      login(user)
      delete "/logout"
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
