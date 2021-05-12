class User < ApplicationRecord
  attr_accessor :remember_token
  attr_accessor :activation_token

  before_create :generate_activation_digest

  has_secure_password
  validates :name, presence: true, length: { in: 2..30 }, uniqueness: true 
  validates :email, presence: true, uniqueness: true, email: { mode: :strict }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def self.generate_digest(string)
    BCrypt::Password.create(string)
  end

  def set_remember_token
    self.remember_token = User.generate_token
    update_attribute(:remember_digest, User.generate_digest(remember_token))
  end

  def delete_remember_token
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  private

    def generate_activation_digest
      self.activation_token = User.generate_token
      self.activation_digest = User.generate_digest(activation_token)
    end

end
