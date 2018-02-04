module Page_Helpers

	STANDARD_KEYWORDS = "photos,photographs,photography,pictures,images"

	# get_page_type
	#
	# Determine the type of the current page.
	
	def get_page_type
	
		return "article" unless current_article.nil?
  		return "tag" unless current_page.metadata[:locals]["tagname"].nil?
  		return "home" if current_page.url == "/"

  		case current_page.metadata[:locals]["page_type"]
  			when "year"
  				return "year"
  			when "month"
  				return "month"
  			when "day"
  				return "day"
  		end
  		
  		# Default is 'static'
  		
  		return "static"
  	end

	def get_page_robots()
		case get_page_type()
			when "tag", "tags", "month"
				return "follow"
		end
		if current_page.data.robots.nil?
			return "index"
		end
		return current_page.data.robots
	end
	
	def get_page_title()
		case get_page_type()
			when "home"
				return config[:sitename]
			when "article"
				return current_article.data.title + " | " + config[:sitename]
			when "tag"
				return current_page.metadata[:locals]["tagname"] + " | " + config[:sitename]
			when "tags"
				return "Tags | " + config[:sitename]
			when "month"
				page_year = current_page.metadata[:locals]["year"]
				page_month = current_page.metadata[:locals]["month"]
				page_date = Date.new(page_year,page_month,1)
				return page_date.strftime("%B %Y") + " | " + config[:sitename]
		end
		return current_page.data.title + " | " + config[:sitename]
	end
		
	def get_page_keywords()
		case get_page_type()
			when "article"
				return current_page.data.tags
			when "tag"
				return current_page.metadata[:locals]["tagname"] + "," + STANDARD_KEYWORDS
			when "tags"
				return "tags," + STANDARD_KEYWORDS
			when "month"
				return get_page_month_name + "," + 
					   current_page.metadata[:locals]["year"].to_s + "," +
					   STANDARD_KEYWORDS
		end
		return current_page.data.tags || STANDARD_KEYWORDS
	end
	
	def get_page_description()
		case get_page_type()
			when "article"
				return "Photo: " + current_article.data.caption
			when "tag"
				return "Index of photographs tagged '" + 
					   current_page.metadata[:locals]["tagname"] + 
					   "' at " +
				       config[:sitename]
			when "tags"
				return "Index of all tags at " + config[:sitename]
			when "month"
				return "Index of photographs taken during " + 
				       get_page_month_name() + " " +
				       current_page.metadata[:locals]["year"].to_s
		end
		return current_page.data.description || ""
	end
				
	def get_page_month_name()
		pageyear = current_page.metadata[:locals]["year"]
		pagemonth = current_page.metadata[:locals]["month"]
		pagedate = Date.new(pageyear,pagemonth,1)
		return pagedate.strftime("%B")
	end
	
	def get_page_meta()
		case get_page_type()
			when "article"
        		return <<~HEREDOC
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:site" content="@#{config[:sitetwitter]}" />
        <meta name="twitter:url" property="og:url" content="#{config[:siteurl]}#{current_article.date.strftime('%m')}/#{current_article.date.strftime('%d')}/" />
        <meta name="twitter:title" property="og:title" content="#{current_article.data.title}" />
        <meta name="twitter:description" property="og:description" content="#{current_article.data.caption}" />
        <meta name="twitter:image" property="og:image" content="#{config[:siteurl]}photos/#{current_article.date.strftime('%Y-%m-%d')}-1920.jpg" />
    	HEREDOC
			when "home"
        		return <<~HEREDOC
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:site" content="@#{config[:sitetwitter]}" />
        <meta name="twitter:url" property="og:url" content="#{config[:siteurl]}" />
        <meta name="twitter:title" property="og:title" content="#{config[:sitename]}" />
        <meta name="twitter:description" property="og:description" content="#{current_page.data.description}" />
        <meta name="twitter:image" property="og:image" content="#{config[:siteurl]}photos/#{config[:siteposter]}-1920.jpg" />
    	HEREDOC
			when "month"
				article = page_articles.reverse[0]
				month_number = article.date.strftime('%m')
				month_name = article.date.strftime('%B')
				photo_datestamp = article.date.strftime('%Y-%m-%d')
        		return <<~HEREDOC
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:site" content="@#{config[:sitetwitter]}" />
        <meta name="twitter:url" property="og:url" content="#{config[:siteurl]}#{month_number}/" />
        <meta name="twitter:title" property="og:title" content="#{month_name} | #{config[:sitename]}" />
        <meta name="twitter:description" property="og:description" content="Photographs taken during #{month_name} #{config[:siteyear]}." />
        <meta name="twitter:image" property="og:image" content="#{config[:siteurl]}photos/#{photo_datestamp}-1920.jpg" />
    	HEREDOC
			when "tag"
				if page_articles.empty?
					return ""
				else
					tagname = current_page.metadata[:locals]["tagname"]
					tagpath = tag_path(tagname)
					article = page_articles.reverse[0]
					photo_datestamp = article.date.strftime('%Y-%m-%d')
        			return <<~HEREDOC
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:site" content="@#{config[:sitetwitter]}" />
        <meta name="twitter:url" property="og:url" content="#{config[:siteurl]}#{tagpath[1..-1]}" />
        <meta name="twitter:title" property="og:title" content="#{tagname} | #{config[:sitename]}" />
        <meta name="twitter:description" property="og:description" content="An index of photographs tagged '#{tagname}'." />
        <meta name="twitter:image" property="og:image" content="#{config[:siteurl]}photos/#{photo_datestamp}-1920.jpg" />
    	HEREDOC
    			end
		end
		return ""
	end
	
end