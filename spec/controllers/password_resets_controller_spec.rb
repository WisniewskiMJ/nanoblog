require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  describe "GET #new" do
    before :each do
      get :new
    end 
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "renders new password reset template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "user exists in database" do
      let(:saved_user) { FactoryBot.create(:user) }
      before :each do
        reset_params = { reset: { email: saved_user.email } }
        post :create, params: reset_params
      end
      it "sets user's reset digest" do
        saved_user.reload
        expect(saved_user.reset_digest).not_to be(nil)
      end
      it "sends password reset email" do
        email_count = ActionMailer::Base.deliveries.count
        reset_params = { reset: { email: saved_user.email } }
        post :create, params: reset_params 
        expect(ActionMailer::Base.deliveries.count).to eq(email_count +1)
      end
      it "displays info message" do
        expect(flash[:info]).to eq('Password reset link has been sent')
      end
      it "redirects to home page" do
        expect(response).to redirect_to(root_url)
      end
    end

    context "user does not exist in database" do
      let(:unsaved_user) { FactoryBot.build(:user) }
      before :each do
        reset_params = { reset: { email: unsaved_user.email } }
        post :create, params: reset_params
      end
      it "displays no user warning message" do
        expect(flash[:danger]).to eq('This email address could not be found')
      end
      it "renders new password reset request page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    context "user exists in database" do
      let(:saved_user) { FactoryBot.create(:user) }
      it "renders password reset form" do
        saved_user.set_reset_digest
        reset_params = { id: saved_user.reset_token, email: saved_user.email }
        get :edit, params: reset_params
        expect(response).to render_template(:edit)
      end
    end

    context "user does not exist in database" do
      let(:unsaved_user) { FactoryBot.build(:user) }
      let(:token) { User.generate_token }
      it "redirects to home page" do
        reset_params = { id: token, email: unsaved_user.email }
        get :edit, params: reset_params
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PATCH #update" do
    let(:user) { FactoryBot.create(:user) }
    context "password reset link is valid" do
      before do
        user.set_reset_digest
      end
      context "new password and password confirmation match" do
        before :each do
          reset_params = { id: user.reset_token, email: user.email, 
                           user: { password: 'newpassword',
                           password_confirmation: 'newpassword'} }
          patch :update, params: reset_params
        end
        it "resets user password" do
          expect(user.authenticate('password')).to eq(user)
          expect(user.reload.authenticate('newpassword')).to eq(user)
        end
        it "displays successful password reset message" do
          expect(flash[:success]).to eq('Your password has been reset')
        end
        it "logs user in" do
          expect(is_logged_in?(user)).to eq(true)
        end
        it "redirects to user show page" do
          expect(response).to redirect_to(user_url(user))
        end
      end
      context "new password and password confirmation do not match" do
        before do
          mismatched_params = { id: user.reset_token, email: user.email, 
                           user: { password: 'newpassword',
                           password_confirmation: 'password'} }
          patch :update, params: mismatched_params
        end
        it "renders password edit form" do
          expect(response).to render_template(:edit)
        end
      end
    end
    context "password reset link is valid" do
      let(:token) { User.generate_token }
      let(:invalid_params) { { id: token, email: user.email, 
                               user: { password: 'newpassword',
                               password_confirmation: 'newpassword'} } }
      it "redirects to home page" do
        patch :update, params: invalid_params
        expect(response).to redirect_to(root_url)
      end
    end
  end
end