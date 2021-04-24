class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, length: { in: 2..30 }, uniqueness: true 
  validates :email, presence: true, uniqueness: true, email: { mode: :strict }
end
