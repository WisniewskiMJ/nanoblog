require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user) }
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

  pending "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
