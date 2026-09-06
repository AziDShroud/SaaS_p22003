class Group < ApplicationRecord
  belongs_to :user #owner/creator of the group
  belongs_to :post, optional: true
  has_one :conversation, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :user
  has_many :users, through: :group_memberships, source: :user
end
