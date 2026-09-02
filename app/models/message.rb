class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates :body, presence: true

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
  #Broadcasts the message in real time to the convo stream
  after_create_commit do
    broadcast_append_to conversation,
                        target: "messages_conversation_#{conversation.id}",
                        partial: "messages/message",
                        locals: {message: self}
  end
end
private
def message_params
  params.require(:message).permit(:body)
end