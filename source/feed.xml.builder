xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = "#{config[:siteurl]}/"
  xml.title "#{config[:sitename]}"
  xml.subtitle "#{config[:siteslug]} by #{config[:siteauthorname]}"
  xml.id URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, blog.options.prefix.to_s)
  xml.link "href" => URI.join(site_url, current_page.path), "rel" => "self"
  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?
  xml.author { xml.name config[:siteauthorname] }

  blog.articles[0..12].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article.url)
      xml.id URI.join(site_url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      xml.author { xml.name config[:siteauthorname] }
      # xml.summary article.summary, "type" => "html"
	  xml.content article.data.caption, "type" => "html"
	  article.tags.sort_by{|tag,articles| tag.downcase}.each do |tag|
	  	xml.category "term" => tag
	  end
    end
  end
end
