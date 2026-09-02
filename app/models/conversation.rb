class Conversation < ApplicationRecord
  enum :conversation_type,{ direct:"direct",group_channel:"group_channel"}
  belongs_to :group, optional: true
  has_many :conversation_memberships, dependent: :destroy
  has_many :users, through: :conversation_memberships
  has_many :messages, dependent: :destroy

  # Finds or creates a 1-1 convo between two users
  def self.direct_between(user1,user2)
    existing = joins(:conversation_memberships)
      .where(conversation_type:"direct")
      .where(conversation_memberships: { user_id: [ user1.id, user2.id ] })
      .group("conversations.id")
      .having("COUNT(conversations.id)=2")
      .first
    return existing if existing

    conversation = create!(conversation_type: "direct")
    conversation.conversation_memberships.create!([{user_id: user1.id},{ user_id: user2.id}])
    conversation
  end
end
