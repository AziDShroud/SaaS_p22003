class Contact < ApplicationRecord
  belongs_to :user
  belongs_to :contact, class_name: "User", foreign_key: "contact_id", optional: true

  validates :contact_id, uniqueness: { scope: :user_id }
  validate :cannot_add_self

  private
  def cannot_add_self
    errors.add(:contact_id, "Can't add self")if user_id == contact_id
  end
end
