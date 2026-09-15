class Todo < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  before_validation :set_created_by
  validates :title, presence: true
  validates :created_by, presence: true

  private
  def set_created_by
    self.created_by ||= user_id.to_s if user_id.present?
  end
end
