class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_one :group, dependent: :destroy
  attr_accessor :category_name

  before_validation :assign_category_from_name
  after_create :create_associated_group

  validates :title, presence: true
  validates :content, presence: true
  validates :category_id, presence: true
  private
  def assign_category_from_name
    if category_name.present?
      self.category = Category.find_or_create_by(name: category_name.strip.capitalize)
    end
  end
  def create_associated_group
    #1 Create a group with post title and content as description, setting post user as the owner
    group = Group.create!(
      name: title,
      description: content,
      user: user,
      post_id: id #Assign post reference if post_id exists on groups table
    )
    #2 Add owner to group members
    group.group_memberships.create(user: user)
  end
end
