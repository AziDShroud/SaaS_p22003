class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge(user: current_user))

      respond_to do |format|
        if @message.save
          format.turbo_stream # Clears input via turbo stream
          format.html{redirect_to root_path}
        else
          format.turbo_stream{head :unprocessable_entity}
          format.html {head :unprocessable_entity}
      end
  end
  end
  private
  def message_params
    params.require(:message).permit(:body)
  end
end

