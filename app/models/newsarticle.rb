class Newsarticle < ActiveRecord::Base

  NR_STORIES_PER_PAGE = 12

  def self.save_story(params)
    @story = Newsarticle.new
    @title = params[:title]
    @story.title = @title
    @story.title_modified = @title.split(' ').join('-')
    @story.author_id = 1
    @story.status = "Active"
    @story.body_raw = params[:body]
    @story.published_first_at = Time.now
    @story.save
  end

  def self.update_story(params)
    @story = Newsarticle.find_by_id(params[:id])
    if @story != nil then 
      @story.title = @title
      @story.title_modified = @title.split(' ').join('-')
      @story.author_id = 1
      @story.status = "Active"
      @story.body_raw = params[:body]
      @story.save
    end
  end

  def self.get_page(params)
    @page = params[:page]
    if @page == nil or @page == "" then 
	@page = 1
    end
    @page = @page.to_i
    return @page
  end
  
  def self.get_nr_stories_per_page
    return NR_STORIES_PER_PAGE 
  end

  def self.get_previous_page(page)
    @previous_page = page.to_i - 1
    if @previous_page == 0 then @previous_page = 1 end
    return @previous_page
  end

  def self.get_next_page(page)
    @next_page = page.to_i + 1
    return @next_page
  end

  def self.get_articles(page)
    @nr_stories_per_page = get_nr_stories_per_page
    @articles = Newsarticle.all.offset(@nr_stories_per_page*(page.to_i-1)).limit(@nr_stories_per_page)
    return @articles
  end

  def self.nr_articles
    return Newsarticle.all.count
  end

  def self.get_nr_pages(nr_articles)
    @nr_stories_per_pages = get_nr_stories_per_page
    @nr_pages = (nr_articles / @nr_stories_per_page) + 1
    if nr_articles % @nr_stories_per_page == 0 then @nr_pages = @nr_pages - 1 end
    return @nr_pages
  end


end
