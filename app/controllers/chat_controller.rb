class ChatController < ApplicationController
   
  def index
    @messages = Chatmessage.order(:id => :desc).limit(10)
    @messages = @messages.reverse
  end

  def save_chat_message
    Chatmessage.save_chat_message(params)    
  end

end
