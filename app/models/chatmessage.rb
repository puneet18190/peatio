class Chatmessage < ActiveRecord::Base

  def self.save_chat_message(params)
    @author = params["author"]
    @message = params["message"]
    Chatmessage.create(author: @author, message: @message)
  end

end
