class NewsadminController < ApplicationController
  #this is to skip the annyoing error 
  skip_before_filter :verify_authenticity_token  

  layout 'newschat.html.erb' 

  def all
    @page = params[:page]
    @newsarticles = Newsarticle.all.order('id desc')
    @count = @newsarticles.count
  end

  def add_story

  end

  def save_story
    Newsarticle.save_story(params)
    flash[:success] = "News story with id " + params[:id].to_s + " saved."
    redirect_to newsadmin_add_story_url
  end

  def edit_story
    @id = params[:story_id]
    @story = Newsarticle.find_by_id(@id)
  end

  def update_story
    Newsarticle.update_story(params)
    flash[:success] = "News story with id "+ params[:id].to_s + " updated."
    redirect_to newsadmin_add_story_url
  end

  def delete_story
    @story_id = params[:story_id]
    @story = Newsarticle.find_by_id(@story_id)
    if @story != nil then 
      flash[:success] = "Story deleted."
      @story.destroy
    else
      flash[:error] = "Story not found."
    end
    redirect_to :back
  end

end
