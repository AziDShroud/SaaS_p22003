class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show]
  def show
    if @conversation.nil?
      redirect_to root_path, alert:"Conversation not found."
      return
    end
    @messages = @conversation.messages.includes(:user)
    respond_to do |format|
      format.html
      format.turbo_stream{render template: "conversations/start_direct"}
    end
  end
  #Opens/Creates Direct Message Modal from Contacts
  def start_direct
    recipient = User.find(params[:recipient_id])
    @conversation = Conversation.direct_between(current_user, recipient)
    respond_to do |format|
      format.turbo_stream
      format.html{redirect_to @conversation}
    end
  end
  #Opens/Creates Group Message modal from Group View
  def start_group
    @group = Group.find(params[:group_id])
    @conversation = Conversation.find_or_create_by(group: @group, conversation_type: "group_channel") do |c|
      c.users = @group.members
  end
  respond_to do |format|
    format.turbo_stream
    format.html{redirect_to @conversation}
  end
end
private
def set_conversation
  conversation_id = params[:id] || params[:conversation_id]
  @conversation = Conversation.find_by(id: conversation_id)
end
end
