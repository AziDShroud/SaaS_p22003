class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  # Contact relationships
  has_many :contacts, dependent: :destroy
  has_many :personal_contacts, through: :contacts, source: :contact
  has_many :received_contacts, class_name: "Contact", foreign_key: :contact_id, dependent: :destroy
  # Group relationships
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
end
