require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(30) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('valid@email.address').for(:email) }
    it { is_expected.to_not allow_value('invalid@email_address').for(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
    it { is_expected.to validate_presence_of(:password_confirmation) }
  end

  describe 'class methods' do
    let(:user) { FactoryBot.create(:user) }
    describe '::generate_token' do
      it 'generates secure random url safe base64 string' do
        expect(User.generate_token).to match(/\S{22,}/)
      end
    end

    describe '::generate_digest' do
      it 'hashes given string' do
        string = 'random_string'
        digest = User.generate_digest(string)
        expect(BCrypt::Password.new(digest).is_password?(string)).to be(true)
      end
    end

    describe '#set_remember_digest' do
      before do
        user.set_remember_digest
      end
      it 'generates remember token' do
        expect(user.remember_token).to match(/|S{22,}/)
      end
      it 'sets remember digest with hashed remember token' do
        expect(BCrypt::Password.new(user.remember_digest).
               is_password?(user.remember_token)).to be(true)
      end
    end

    describe '#delete_remember_digest' do
      before do
        user.set_remember_digest
        user.delete_remember_digest
      end
      it 'deletes remember token' do
        expect(user.remember_token).to be(nil)
      end
      it 'sets remember digest to nil' do
        expect(user.remember_digest).to be(nil)
      end
    end

    describe '#authenticated?' do
      let(:other_token) { User.generate_token }
      before do
        user.set_remember_digest
        user.set_reset_digest
      end
      it 'returns true if given action token matches corresponding action digest' do
        expect(user.authenticated?(:remember, user.remember_token)).to be(true)
        expect(user.authenticated?(:reset, user.reset_token)).to be(true)
      end
      it 'returns false if given action token does not match corresponding action digest' do
        expect(user.authenticated?(:remember, other_token)).to be(false)
        expect(user.authenticated?(:reset, other_token)).to be(false)
      end
    end

    describe '#send_activation_email' do
      it 'sends activation email to user' do
        email_count = ActionMailer::Base.deliveries.count
        user.send_activation_email
        expect(ActionMailer::Base.deliveries.count).to eq(email_count +1)
      end
    end

    describe '#activate!' do
      before do
        user.activate!
      end
      it 'sets user activated column to true' do
        expect(user.activated?).to be(true)
      end
      it 'marks user activation time' do
        expect(user.activated_at).to be_within(1.second).of Time.now
      end
    end

    describe '#set_reset_digest' do
      before do
        user.set_reset_digest
      end
      it 'generates reset token' do
        expect(user.reset_token).to match(/|S{22,}/)
      end
      it 'sets reset digest with hashed remember token' do
        expect(BCrypt::Password.new(user.reset_digest).
               is_password?(user.reset_token)).to be(true)
      end
    end
    
    describe '#send_reset_email' do
      it 'sends password reset email to user' do
        email_count = ActionMailer::Base.deliveries.count
        user.set_reset_digest
        user.send_reset_email
        expect(ActionMailer::Base.deliveries.count).to eq(email_count +1)
      end
    end
  end
end
