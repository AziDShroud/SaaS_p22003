class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy

  validates :name, presence: {message: "can't be empty"}
  validates :email, presence: {message: "can't be empty"}, uniqueness: {message: "User already exists"}
  validates :password, presence: true
end
