require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }
    describe "headers" do
      it "is titled 'Account activation'" do
        expect(mail.subject).to eq("Account activation")
      end
      it "is sent to user email address" do
        expect(mail.to).to eq([user.email])
      end
    end

    describe "body" do
      it "includes user name" do
        expect(mail.body.encoded).to match(user.name)
      end
      it "includes escaped user email address" do
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
      it "includes user activation token" do
        expect(mail.body.encoded).to match(user.activation_token)
      end
    end
  end

  describe "password_reset" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }
    before do
      user.set_reset_digest
    end
    describe "headers" do
      it "is titled 'Password reset'" do
        expect(mail.subject).to eq("Password reset")
      end
      it "is sent to user email address" do
        expect(mail.to).to eq([user.email])
      end
    end
  
      describe "body" do
        it "includes user name" do
          expect(mail.body.encoded).to match(user.name)
        end
        it "includes escaped user email address" do
          expect(mail.body.encoded).to match(CGI.escape(user.email))
        end
        it "includes user reset token" do
          expect(mail.body.encoded).to match(user.reset_token)
        end
      end
    end
end
