class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :body, presence: true
  after_create_commit :broadcast_message_and_notifications
 def create
   @conversation = Conversation.find(params[:conversation_id])
   @message = @converation.messages.build(message_params.merge(user: current_user))
   if @message.save
     respond_to do |format|
       format.turbo_stream
       format.html{redirect_to @conversation}
     end
   end
 end
end
private
def message_params
  params.require(:message).permit(:body)
end
def broadcast_message_and_notifications
  # Broadcasts the message in real time to the convo stream
  broadcast_append_to conversation,
                      target: "messages_conversation_#{conversation.id}",
                      partial: "messages/message",
                      locals: { message: self }
  # Broadcast the notifications to all recipients
  recipients = conversation.users.where.not(id: user.id).distinct
  recipients.each do |recipient|
    broadcast_prepend_to "notifications_user_#{recipient.id}",
                         target: "flash_notifications",
                         partial: "messages/notification",
                         locals: { message: self, recipient: recipient }
  end
end
