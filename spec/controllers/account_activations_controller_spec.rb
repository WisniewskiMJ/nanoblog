require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  describe "GET #edit" do
    
    context "activation link is valid" do
      before :each do
        get :edit, params: { id: user.activation_token, email: user.email }
      end
      it "activates user account" do
        expect(user.reload.activated?).to eq(true)
      end
      it "sets activation time" do
        expect(user.reload.activated_at).not_to be(nil)
      end
      it "logs user in" do
        expect(is_logged_in?(user)).to eq(true)
      end
      it "displays successful activation message" do
        expect(flash[:success]).to eq('Your user account have been activated!')
      end
      it "redirects to user show page" do
        expect(response).to redirect_to(user_url(user))
      end
    end

    context "activation link is invalid" do
      before :each do
        get :edit, params: { id: 'random string', email: user.email }
      end
      it "displays warning message" do
        expect(flash[:danger]).to eq('Invalid activation link')
      end
      it "redirects to home page" do
        expect(response).to redirect_to(root_url)
      end
    end
  end
end