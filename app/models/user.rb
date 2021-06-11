# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string
#  admin             :boolean          default(FALSE)
#  email             :string
#  name              :string
#  password_digest   :string
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
class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :set_activation_digest

  has_secure_password
  validates :name, presence: true, length: { in: 2..30 }, uniqueness: true 
  validates :email, presence: true, uniqueness: true, email: { mode: :strict }
  # validates :password, presence: true, length: { minimum: 8 }
  # validates :password_confirmation, presence: true

  has_one_attached :avatar

  has_many :posts,
           dependent: :destroy

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def self.generate_digest(string)
    BCrypt::Password.create(string)
  end

  def set_remember_digest
    self.remember_token = User.generate_token
    update_attribute(:remember_digest, User.generate_digest(remember_token))
  end

  def delete_remember_digest
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(action, token)
    digest = send("#{action}_digest") # == self.send()
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate!
    self.update_attribute(:activated, true)
    self.update_attribute(:activated_at, Time.zone.now)
  end

  def set_reset_digest
    self.reset_token = User.generate_token
    update_attribute(:reset_digest, User.generate_digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_reset_email
     UserMailer.password_reset(self).deliver_now
  end

  def feed
    Post.all
  end

  private

    def set_activation_digest
      self.activation_token = User.generate_token
      self.activation_digest = User.generate_digest(activation_token)
    end

end
