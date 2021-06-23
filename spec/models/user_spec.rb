# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string
#  admin             :boolean          default(FALSE)
#  email             :string           not null
#  name              :string           not null
#  password_digest   :string           not null
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { User.new(name: 'Example', email: 'example@example.com', 
              password_digest: User.generate_digest(User.generate_token)) }
   
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

  describe 'associations' do
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:active_relationships).dependent(:destroy) }
    it { should have_many(:passive_relationships).dependent(:destroy) }
    it { should have_many(:followers).through(:passive_relationships) }
    it { should have_many(:following).through(:active_relationships)  }
  end

  describe 'class methods' do
    let(:user) { FactoryBot.create(:user) }
    describe '.generate_token' do
      it 'generates secure random url safe base64 string' do
        expect(User.generate_token).to match(/\S{22,}/)
      end
    end

    describe '.generate_digest' do
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
        expect(BCrypt::Password.new(user.remember_digest)
               .is_password?(user.remember_token)).to be(true)
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
        expect(ActionMailer::Base.deliveries.count).to eq(email_count + 1)
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
        expect(user.activated_at).to be_within(1.second).of Time.zone.now
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
        expect(BCrypt::Password.new(user.reset_digest)
               .is_password?(user.reset_token)).to be(true)
      end
    end

    describe '#delete_reset_digest' do
      before do
        user.set_reset_digest
        user.delete_reset_digest
      end
      it 'sets reset digest to nil' do
        expect(user.reset_digest).to be(nil)
      end
      it 'sets reset_sent_at to nil' do
        expect(user.reset_sent_at).to be(nil)
      end
    end

    describe '#new_activation_digest' do
      before do
        user.new_activation_digest
      end
      it 'generates activation token' do
        expect(user.activation_token).to match(/|S{22,}/)
      end
      it 'sets activation digest with hashed activation token' do
        expect(BCrypt::Password.new(user.activation_digest)
               .is_password?(user.activation_token)).to be(true)
      end
    end

    describe '#send_reset_email' do
      it 'sends password reset email to user' do
        email_count = ActionMailer::Base.deliveries.count
        user.set_reset_digest
        user.send_reset_email
        expect(ActionMailer::Base.deliveries.count).to eq(email_count + 1)
      end
    end

    describe '#feed' do
      it 'returns users and their following posts' do
        other_user = FactoryBot.create(:user)
        own_post = FactoryBot.create(:post, user_id: user.id)
        user.following << other_user
        followed_user_post = create(:post, user_id: other_user.id)
        posts = user.feed
        expect(posts).to eq([followed_user_post, own_post])
      end
    end
  end
end
