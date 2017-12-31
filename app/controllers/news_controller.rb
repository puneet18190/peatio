class NewsController < ApplicationController
 
  def index
    @page = Newsarticle.get_page(params)
    @nr_stories_per_page = Newsarticle.get_nr_stories_per_page
    @articles = Newsarticle.get_articles(@page)
    @previous_page = Newsarticle.get_previous_page(@page)
    @next_page = Newsarticle.get_next_page(@page)
    @nr_articles = Newsarticle.nr_articles
    @last_page = Newsarticle.get_nr_pages(@nr_articles)
  end

  def story
    @id = params[:id]
    @story = Newsarticle.find_by_id(@id)    
  end

end
  
