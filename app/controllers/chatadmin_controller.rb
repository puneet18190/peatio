class ChatadminController < ApplicationController

  layout 'newschat.html.erb' 

  def all
    @page = params[:page]
    @chatmessages = Chatmessage.all.order('id desc')
  end

  def add_chatmessage

  end

  def save_chatmessage

  end

  def edit_chatmessage

  end

  def update_chatmessage

  end

  def delete_chatmessage

  end


  def delete_chathistory

  end

end
