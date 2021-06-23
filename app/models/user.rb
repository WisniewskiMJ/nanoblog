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
class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_create :set_activation_digest

  has_secure_password
  validates :name, presence: true, length: { in: 2..30 }, uniqueness: true
  validates :email, presence: true, uniqueness: true, email: { mode: :strict }
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  validates :password_confirmation, presence: true, on: :create

  has_one_attached :avatar
  has_one_attached :background_image

  has_many :posts,
           dependent: :destroy

  has_many :active_relationships,
           foreign_key: :follower_id,
           class_name: :Relationship,
           dependent: :destroy,
           inverse_of: :follower

  has_many :passive_relationships,
           foreign_key: :followed_id,
           class_name: :Relationship,
           dependent: :destroy,
           inverse_of: :followed

  has_many :followers,
           through: :passive_relationships

  has_many :following,
           through: :active_relationships,
           source: :followed

  def self.generate_token
    SecureRandom.urlsafe_base64
  end

  def self.generate_digest(string)
    BCrypt::Password.create(string)
  end

  def set_remember_digest
    self.remember_token = User.generate_token
    update(remember_digest: User.generate_digest(remember_token))
  end

  def delete_remember_digest
    self.remember_token = nil
    update(remember_digest: nil)
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
    update(activated: true, activated_at: Time.zone.now)
  end

  def set_reset_digest
    self.reset_token = User.generate_token
    update(reset_digest: User.generate_digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def delete_reset_digest
    update(reset_digest: nil, reset_sent_at: nil)
  end

  def new_activation_digest
    self.activation_token = User.generate_token
    update(activation_digest: User.generate_digest(activation_token))
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
      WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                OR user_id = :user_id", user_id: id)
  end
  private

  def set_activation_digest
    self.activation_token = User.generate_token
    self.activation_digest = User.generate_digest(activation_token)
  end
end
